import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn, CreateDateColumn } from 'typeorm';
import { Challenge } from '../../challenge/entities/challenge.entity';
import { Mission } from '../../mission/entities/mission.entity';
import { User } from '../../user/entities/user.entity';

export enum AttemptStatus {
    PENDING = 'PENDING',
    SUBMITTED = 'SUBMITTED',
    PASS = 'PASS',
    FAIL = 'FAIL',
    REVIEW = 'REVIEW',
}

@Entity()
export class Attempt {
    @PrimaryGeneratedColumn('uuid')
    id: string;

    @ManyToOne(() => Challenge)
    @JoinColumn({ name: 'challenge_id' })
    challenge: Challenge;

    @Column()
    challenge_id: string;

    @ManyToOne(() => Mission)
    @JoinColumn({ name: 'mission_id' })
    mission: Mission;

    @Column()
    mission_id: string;

    @ManyToOne(() => User)
    @JoinColumn({ name: 'user_id' })
    user: User;

    @Column()
    user_id: string; // Add this column explicitly

    @Column({
        type: 'text',
        default: AttemptStatus.PENDING,
    })
    status: AttemptStatus;

    @Column({ nullable: true })
    submitted_at: Date;

    @Column({ nullable: true })
    media_url: string;

    @Column({ nullable: true })
    judge_reason_code: string; // 'TIMEOUT', 'MISSION_MISMATCH'

    @CreateDateColumn()
    created_at: Date;
}
