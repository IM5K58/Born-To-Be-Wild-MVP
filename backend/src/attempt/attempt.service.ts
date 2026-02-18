import { Injectable, BadRequestException, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Attempt, AttemptStatus } from './entities/attempt.entity';
import { ChallengeService } from '../challenge/challenge.service';

@Injectable()
export class AttemptService {
  constructor(
    @InjectRepository(Attempt)
    private attemptsRepository: Repository<Attempt>,
    private readonly challengeService: ChallengeService,
  ) { }

  async submitProof(
    userId: string,
    data: { challenge_id: string; mission_id: string; file: Express.Multer.File; nonce: string },
  ) {
    const challenge = await this.challengeService.findOne(data.challenge_id);
    if (!challenge) throw new NotFoundException('Challenge not found');

    const now = new Date();
    const currentTimeStr = now.toLocaleTimeString('en-US', { hour12: false, hour: '2-digit', minute: '2-digit' });

    // Simple Time Window Check (MVP)
    // Assuming proof_window_end is "HH:mm"
    let status = AttemptStatus.SUBMITTED;
    let reason: string | null = null;

    if (challenge.proof_window_end && currentTimeStr > challenge.proof_window_end) {
      status = AttemptStatus.FAIL;
      reason = 'TIMEOUT';
    } else {
      // For MVP, if on time -> PASS immediately (skip AI/Manual Review for now unless flag is set)
      status = AttemptStatus.PASS;
    }

    // Mock S3 Upload
    const mockUrl = `https://s3.amazonaws.com/beast-heart-mvp/${data.challenge_id}/${now.getTime()}.jpg`;

    const attempt = this.attemptsRepository.create({
      challenge_id: data.challenge_id,
      mission_id: data.mission_id,
      user_id: userId,
      media_url: mockUrl,
      status,
      judge_reason_code: reason || undefined, // Allow undefined if null
      submitted_at: now,
    });

    return this.attemptsRepository.save(attempt);
  }

  async findAll(userId: string) {
    return this.attemptsRepository.find({
      where: { user_id: userId },
      relations: ['mission'],
      order: { created_at: 'DESC' },
    });
  }

  async findOne(id: string) {
    return this.attemptsRepository.findOne({ where: { id }, relations: ['mission'] });
  }

  async getSuccessCount(challengeId: string): Promise<number> {
    return this.attemptsRepository.count({
      where: {
        challenge_id: challengeId,
        status: AttemptStatus.PASS,
      },
    });
  }
}
