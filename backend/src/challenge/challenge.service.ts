import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Challenge, ChallengeStatus } from './entities/challenge.entity';
import { Deposit, DepositStatus } from './entities/deposit.entity';
import { CreateChallengeDto } from './dto/create-challenge.dto';

@Injectable()
export class ChallengeService {
  constructor(
    @InjectRepository(Challenge)
    private challengesRepository: Repository<Challenge>,
    @InjectRepository(Deposit)
    private depositsRepository: Repository<Deposit>,
  ) { }

  async create(createChallengeDto: CreateChallengeDto & { user_id: string }) {
    const challenge = this.challengesRepository.create({
      ...createChallengeDto,
      status: ChallengeStatus.DRAFT,
    });
    return this.challengesRepository.save(challenge);
  }

  async activate(id: string, amount: number) {
    const challenge = await this.challengesRepository.findOne({ where: { id } });
    if (!challenge) throw new NotFoundException('Challenge not found');
    if (challenge.status !== ChallengeStatus.DRAFT) throw new BadRequestException('Challenge must be in DRAFT status');

    // Mock Payment Success
    const deposit = this.depositsRepository.create({
      challenge_id: challenge.id,
      user_id: challenge.user_id,
      amount,
      status: DepositStatus.LOCKED,
    });
    await this.depositsRepository.save(deposit);

    challenge.status = ChallengeStatus.ACTIVE;
    challenge.start_at = new Date().toISOString().split('T')[0]; // Start today
    // Calculate end date based on duration (simple logic for MVP)
    const endDate = new Date();
    endDate.setDate(endDate.getDate() + 30); // Default 30 days if not specified
    challenge.end_at = endDate.toISOString().split('T')[0];

    await this.challengesRepository.save(challenge);
    return this.findOne(challenge.id); // Return full object with relations
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
      challenge.deposit.status = DepositStatus.SETTLED;
      challenge.deposit.settled_type = success ? 'REFUNDED' : (challenge.failure_rule || 'BURNED');
      await this.depositsRepository.save(challenge.deposit);
    }
  }
}
