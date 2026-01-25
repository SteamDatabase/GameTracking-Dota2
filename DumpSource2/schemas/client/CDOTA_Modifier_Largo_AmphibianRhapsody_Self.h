class CDOTA_Modifier_Largo_AmphibianRhapsody_Self : public CDOTA_Buff
{
	float32 radius;
	float32 duration;
	float32 rhythm_interval;
	float32 rhythm_grace_period;
	float32 armor_per_stack;
	int32 max_stacks;
	float32 stack_duration;
	int32 double_song;
	int32 stack_decrement_on_exit;
	AmphibianRhapsodySong_t m_nCurrentSong;
	AmphibianRhapsodySong_t m_nCurrentSecondSong;
	int32 m_nCurrentSongMusicTrack;
	float32 m_flAnticipatePoseTime;
	bool m_bPlayFinishSongSound;
	bool bRhythmFXStarted;
	float32 m_flNextRestartParticleTime;
	int32 m_iPoseParameterAnticipation;
	float32 m_flLastPoseTime;
	bool m_bMusicStarted;
};
