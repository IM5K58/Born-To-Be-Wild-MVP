import { Module } from '@nestjs/common';
import { SettlementService } from './settlement.service';
import { SettlementController } from './settlement.controller';
import { ChallengeModule } from '../challenge/challenge.module';
import { AttemptModule } from '../attempt/attempt.module';

@Module({
  imports: [ChallengeModule, AttemptModule],
  controllers: [SettlementController],
  providers: [SettlementService],
})
export class SettlementModule { }
