import { Entity, PrimaryGeneratedColumn, Column, OneToOne, JoinColumn, CreateDateColumn } from 'typeorm';
// eslint-disable-next-line import/no-cycle
import { Challenge } from './challenge.entity';
import { User } from '../../user/entities/user.entity';

export enum DepositStatus {
    LOCKED = 'LOCKED',
    AT_RISK = 'AT_RISK',
    SETTLED = 'SETTLED',
}

@Entity()
export class Deposit {
    @PrimaryGeneratedColumn('uuid')
    id: string;

    @OneToOne(() => Challenge, (challenge) => challenge.deposit)
    @JoinColumn({ name: 'challenge_id' })
    challenge: Challenge;

    @Column()
    challenge_id: string;

    @Column()
    user_id: string;

    @Column({ type: 'decimal', precision: 10, scale: 2 })
    amount: number;

    @Column({
        type: 'text',
        default: DepositStatus.LOCKED,
    })
    status: DepositStatus;

    @Column({ nullable: true })
    settled_type: string; // 'REFUNDED', 'BURNED', 'CREDITED', 'DONATED'

    @CreateDateColumn()
    created_at: Date;
}
