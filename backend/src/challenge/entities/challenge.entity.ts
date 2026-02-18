import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, OneToOne, JoinColumn, CreateDateColumn } from 'typeorm';
import { User } from '../../user/entities/user.entity';
// eslint-disable-next-line import/no-cycle
import { Deposit } from './deposit.entity';

export enum ChallengeStatus {
    DRAFT = 'DRAFT',
    ACTIVE = 'ACTIVE',
    COMPLETED = 'COMPLETED',
    FAILED = 'FAILED',
    CANCELLED = 'CANCELLED',
}

@Entity()
export class Challenge {
    @PrimaryGeneratedColumn('uuid')
    id: string;

    @ManyToOne(() => User)
    @JoinColumn({ name: 'user_id' })
    user: User;

    @Column()
    user_id: string;

    @Column()
    template_id: string; // e.g., 'wakeup', 'commit'

    @Column({
        type: 'text', // 'enum' in postgres, but text is simpler for MVP
        default: ChallengeStatus.DRAFT,
    })
    status: ChallengeStatus;

    @Column({ type: 'date', nullable: true })
    start_at: string;

    @Column({ type: 'date', nullable: true })
    end_at: string;

    @Column({ default: 7 })
    frequency_per_week: number;

    @Column({ nullable: true })
    proof_window_start: string; // "06:00"

    @Column({ nullable: true })
    proof_window_end: string; // "06:20"

    @Column({ default: 'photo' })
    proof_type: string;

    @Column({ nullable: true })
    failure_rule: string; // 'BURN', 'CREDIT', 'DONATE'

    @Column({ nullable: true })
    donate_target: string; // e.g., 'unicef', 'greenpeace', 'save_children'

    @OneToOne(() => Deposit, (deposit) => deposit.challenge, { cascade: true })
    deposit: Deposit;

    @CreateDateColumn()
    created_at: Date;
}
