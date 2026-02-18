import { Controller, Post } from '@nestjs/common';
import { SettlementService } from './settlement.service';

@Controller('settlements')
export class SettlementController {
  constructor(private readonly settlementService: SettlementService) { }

  @Post('run')
  run() {
    return this.settlementService.runSettlement();
  }
}
