import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AttemptService } from './attempt.service';
import { AttemptController } from './attempt.controller';
import { Attempt } from './entities/attempt.entity';
import { ChallengeModule } from '../challenge/challenge.module'; // Import ChallengeModule for validation

@Module({
  imports: [
    TypeOrmModule.forFeature([Attempt]),
    ChallengeModule, // To access ChallengeService (for time window check)
  ],
  controllers: [AttemptController],
  providers: [AttemptService],
  exports: [AttemptService],
})
export class AttemptModule { }
