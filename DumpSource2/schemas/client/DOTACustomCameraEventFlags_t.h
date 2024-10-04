enum DOTACustomCameraEventFlags_t : uint32_t
{
	k_ECustomCameraEventFlags_Zoom = 1,
	k_ECustomCameraEventFlags_Position = 2,
	k_ECustomCameraEventFlags_PositionPlayerHero = 4,
	k_ECustomCameraEventFlags_Pitch = 8,
	k_ECustomCameraEventFlags_Yaw = 16,
	k_ECustomCameraEventFlags_Lock = 32,
	k_ECustomCameraEventFlags_Unlock = 64,
	k_ECustomCameraEventFlags_ResetDefault = 128,
	k_ECustomCameraEventFlags_SpecificPlayer = 256,
	k_ECustomCameraEventFlags_FadeOut = 512,
	k_ECustomCameraEventFlags_FadeIn = 1024,
	k_ECustomCameraEventFlags_LetterboxOn = 2048,
	k_ECustomCameraEventFlags_LetterboxOff = 4096,
};
