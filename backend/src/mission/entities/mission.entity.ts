import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn, CreateDateColumn } from 'typeorm';
import { Challenge } from '../../challenge/entities/challenge.entity';

@Entity()
export class Mission {
    @PrimaryGeneratedColumn('uuid')
    id: string;

    @ManyToOne(() => Challenge)
    @JoinColumn({ name: 'challenge_id' })
    challenge: Challenge;

    @Column()
    challenge_id: string;

    @Column({ type: 'date' })
    date: string; // YYYY-MM-DD

    @Column()
    day_index: number; // 1, 2, 3...

    @Column()
    codeword: string; // e.g., 'BEAST-482'

    @Column()
    gesture: string; // 'V', 'thumbs_up', 'open_palm'

    @Column()
    overlay_text: string;

    @CreateDateColumn()
    created_at: Date;
}
