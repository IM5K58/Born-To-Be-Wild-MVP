import { Controller, Get, Param, Query } from '@nestjs/common';
import { MissionService } from './mission.service';

@Controller('missions')
export class MissionController {
  constructor(private readonly missionService: MissionService) { }

  @Get('today')
  getToday(@Query('challenge_id') challengeId: string) {
    // In real app, challengeId might be inferred from user context or just passed
    return this.missionService.getTodayMission(challengeId);
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.missionService.findOne(id);
  }
}
