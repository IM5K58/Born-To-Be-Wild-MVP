import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Challenge, ChallengeStatus } from './entities/challenge.entity';
import { Deposit, DepositStatus } from './entities/deposit.entity';
import { CreateChallengeDto } from './dto/create-challenge.dto';
import { User } from '../user/entities/user.entity';

@Injectable()
export class ChallengeService {
  constructor(
    @InjectRepository(Challenge)
    private challengesRepository: Repository<Challenge>,
    @InjectRepository(Deposit)
    private depositsRepository: Repository<Deposit>,
    @InjectRepository(User)
    private usersRepository: Repository<User>,
  ) { }

  async create(dto: CreateChallengeDto & { user_id: string }) {
    // CREDIT 방식은 1회만 허용 — 이미 사용했으면 거부
    if (dto.failure_rule === 'CREDIT') {
      const user = await this.usersRepository.findOne({ where: { id: dto.user_id } });
      if (user?.credit_used) {
        throw new BadRequestException('크레딧 전환은 최초 1회만 선택 가능합니다.');
      }
    }

    const challenge = this.challengesRepository.create({
      ...dto,
      status: ChallengeStatus.DRAFT,
    });
    return this.challengesRepository.save(challenge);
  }

  async activate(id: string, amount: number, durationDays: number = 30) {
    const challenge = await this.challengesRepository.findOne({ where: { id } });
    if (!challenge) throw new NotFoundException('Challenge not found');
    if (challenge.status !== ChallengeStatus.DRAFT) throw new BadRequestException('Challenge must be in DRAFT status');

    const deposit = this.depositsRepository.create({
      challenge_id: challenge.id,
      user_id: challenge.user_id,
      amount,
      status: DepositStatus.LOCKED,
    });
    await this.depositsRepository.save(deposit);

    challenge.status = ChallengeStatus.ACTIVE;
    challenge.start_at = new Date().toISOString().split('T')[0];
    const endDate = new Date();
    endDate.setDate(endDate.getDate() + durationDays);
    challenge.end_at = endDate.toISOString().split('T')[0];

    await this.challengesRepository.save(challenge);
    return this.findOne(challenge.id);
  }

  async findAll(userId: string) {
    return this.challengesRepository.find({
      where: { user_id: userId },
      relations: ['deposit'],
      order: { created_at: 'DESC' },
    });
  }

  async findOne(id: string) {
    return this.challengesRepository.findOne({
      where: { id },
      relations: ['deposit'],
    });
  }

  async findExpiredActiveChallenges(): Promise<Challenge[]> {
    return this.challengesRepository.createQueryBuilder('challenge')
      .leftJoinAndSelect('challenge.deposit', 'deposit')
      .where('challenge.status = :status', { status: ChallengeStatus.ACTIVE })
      .andWhere('challenge.end_at < :now', { now: new Date().toISOString().split('T')[0] })
      .getMany();
  }

  async settleChallenge(id: string, success: boolean) {
    const challenge = await this.findOne(id);
    if (!challenge) return;

    challenge.status = success ? ChallengeStatus.COMPLETED : ChallengeStatus.FAILED;
    await this.challengesRepository.save(challenge);

    if (challenge.deposit) {
      const settledType = success ? 'REFUNDED' : (challenge.failure_rule || 'BURNED');
      challenge.deposit.status = DepositStatus.SETTLED;
      challenge.deposit.settled_type = settledType;
      await this.depositsRepository.save(challenge.deposit);

      // 실패 + CREDIT 방식: 크레딧 적립 & 1회 사용 처리
      if (!success && challenge.failure_rule === 'CREDIT') {
        const user = await this.usersRepository.findOne({ where: { id: challenge.user_id } });
        if (user && !user.credit_used) {
          user.credits += Number(challenge.deposit.amount);
          user.credit_used = true;
          await this.usersRepository.save(user);
        }
      }
    }
  }
}
