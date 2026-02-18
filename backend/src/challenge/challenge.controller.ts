import { Controller, Get, Post, Body, Patch, Param, Delete, Query } from '@nestjs/common';
import { ChallengeService } from './challenge.service';
import { CreateChallengeDto } from './dto/create-challenge.dto';

@Controller('challenges')
export class ChallengeController {
  constructor(private readonly challengeService: ChallengeService) { }

  @Post()
  create(@Body() createChallengeDto: CreateChallengeDto & { user_id: string }) {
    // In real app, user_id should come from AuthGuard/Request
    return this.challengeService.create(createChallengeDto);
  }

  @Post(':id/activate')
  activate(@Param('id') id: string, @Body('amount') amount: number, @Body('duration_days') durationDays: number) {
    return this.challengeService.activate(id, amount, durationDays ?? 30);
  }

  @Get()
  findAll(@Query('user_id') userId: string) {
    return this.challengeService.findAll(userId);
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.challengeService.findOne(id);
  }
}
