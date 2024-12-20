extends Node


signal OnWinGame
signal OnHoverItem(Interactable) #name of item grabbed
signal OnStopHoverItem(Interactable)
signal OnPickupItem(String) #name of item grabbed
signal OnDropItem
signal OnCrumpReachedButton
signal OnGameReload

signal OnCrumpGunShot()
signal OnDogGunShot()
signal OnButtonRestored()
