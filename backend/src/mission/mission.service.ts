import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Mission } from './entities/mission.entity';

@Injectable()
export class MissionService {
  constructor(
    @InjectRepository(Mission)
    private missionsRepository: Repository<Mission>,
  ) { }

  async getTodayMission(challengeId: string): Promise<Mission> {
    const today = new Date().toISOString().split('T')[0];
    let mission = await this.missionsRepository.findOne({
      where: { challenge_id: challengeId, date: today },
    });

    if (!mission) {
      mission = await this.generateMission(challengeId, today);
    }
    return mission;
  }

  // In real app, this might be called by a cron job for many users
  private async generateMission(challengeId: string, date: string): Promise<Mission> {
    const codewords = ['BEAST', 'IRON', 'STEEL', 'LION', 'TIGER', 'WOLF'];
    const gestures = ['V', 'thumbs_up', 'open_palm', 'fist'];

    const randomCodeword = `${codewords[Math.floor(Math.random() * codewords.length)]}-${Math.floor(100 + Math.random() * 900)}`;
    const randomGesture = gestures[Math.floor(Math.random() * gestures.length)];

    const mission = this.missionsRepository.create({
      challenge_id: challengeId,
      date,
      day_index: 0, // In real app, calculate diff from challenge start date
      codeword: randomCodeword,
      gesture: randomGesture,
      overlay_text: `Code: ${randomCodeword} / Gesture: ${randomGesture}`,
    });

    return this.missionsRepository.save(mission);
  }

  async findOne(id: string) {
    return this.missionsRepository.findOne({ where: { id } });
  }
}
