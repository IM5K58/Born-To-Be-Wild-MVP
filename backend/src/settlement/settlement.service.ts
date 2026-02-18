import { Injectable } from '@nestjs/common';
import { ChallengeService } from '../challenge/challenge.service';
import { AttemptService } from '../attempt/attempt.service';

@Injectable()
export class SettlementService {
  constructor(
    private readonly challengeService: ChallengeService,
    private readonly attemptService: AttemptService,
  ) { }

  async runSettlement() {
    const expiredChallenges = await this.challengeService.findExpiredActiveChallenges();
    const results: any[] = [];

    for (const challenge of expiredChallenges) {
      const successCount = await this.attemptService.getSuccessCount(challenge.id);

      // Determine required days (simple MVP logic: 80% of duration)
      // If duration_days exists in Challenge entity (I didn't add it explicitly to entity but it was in DTO)
      // I added start_at and end_at. I can calculate days diff.
      // But let's assume 'frequency_per_week' * weeks logic or just simple pass count.
      // For MVP, if successCount >= 1 -> Pass (Super easy MVP) or check frequency.
      // Let's use 80% rule if I can calculate total days. 
      // challenge.end_at - challenge.start_at

      const start = new Date(challenge.start_at);
      const end = new Date(challenge.end_at);
      const diffTime = Math.abs(end.getTime() - start.getTime());
      const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24)) + 1;

      const requiredDays = Math.ceil(diffDays * 0.8);
      const isSuccess = successCount >= requiredDays;

      await this.challengeService.settleChallenge(challenge.id, isSuccess);

      results.push({
        challenge_id: challenge.id,
        user_id: challenge.user_id,
        total_days: diffDays,
        success_days: successCount,
        result: isSuccess ? 'SUCCESS' : 'FAIL',
        settled_type: isSuccess ? 'REFUNDED' : (challenge.failure_rule || 'BURNED'),
      });
    }

    return {
      processed_count: expiredChallenges.length,
      details: results,
    };
  }
}
