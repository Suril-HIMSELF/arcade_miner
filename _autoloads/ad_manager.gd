extends Node

signal rewarded_availability_changed(available: bool)

var ad_view: AdView

var rewarded_ad: RewardedAd
var rewarded_ad_loader: RewardedAdLoader
var reward_callback: Callable = Callable()
var full_screen_content_callback: FullScreenContentCallback
var rewarded_ad_loading := false

const TEST_REWARDED_ID := "ca-app-pub-3940256099942544/5224354917"

func _ready() -> void:
	var initialization_listener := OnInitializationCompleteListener.new()
	initialization_listener.on_initialization_complete = _on_admob_initialization_complete

	MobileAds.initialize(initialization_listener)


func _on_admob_initialization_complete(initialization_status: InitializationStatus) -> void:
	rewarded_ad_loader = RewardedAdLoader.new()

	full_screen_content_callback = FullScreenContentCallback.new()
	full_screen_content_callback.on_ad_dismissed_full_screen_content = _on_rewarded_ad_dismissed
	full_screen_content_callback.on_ad_failed_to_show_full_screen_content = _on_rewarded_ad_failed_to_show

	load_rewarded_ad()


# --------------------------------------------------
# BANNIÈRE
# --------------------------------------------------

func show_banner() -> void:
	if ad_view != null:
		return
	
	var test_banner_id := "ca-app-pub-3940256099942544/6300978111"
	
	ad_view = AdView.new(test_banner_id, AdSize.BANNER, AdPosition.BOTTOM)
	ad_view.load_ad(AdRequest.new())


func hide_banner() -> void:
	if ad_view != null:
		ad_view.hide()


# --------------------------------------------------
# PUBLICITÉ RÉCOMPENSÉE
# --------------------------------------------------

func create_rewarded_ad_load_callback() -> RewardedAdLoadCallback:
	var callback := RewardedAdLoadCallback.new()

	callback.on_ad_loaded = _on_rewarded_ad_loaded
	callback.on_ad_failed_to_load = _on_rewarded_ad_failed_to_load

	return callback


func _on_rewarded_ad_loaded(loaded_ad: RewardedAd) -> void:
	rewarded_ad_loading = false

	rewarded_ad = loaded_ad
	rewarded_ad.full_screen_content_callback = full_screen_content_callback

	rewarded_availability_changed.emit(true)


func _on_rewarded_ad_failed_to_load(error: LoadAdError) -> void:
	rewarded_ad_loading = false
	rewarded_ad = null

	print("REWARDED : échec du chargement : ", error)

	rewarded_availability_changed.emit(false)


func load_rewarded_ad() -> void:

	if rewarded_ad_loading:
		return

	if rewarded_ad != null:
		return

	rewarded_ad_loading = true

	# Nouveau loader pour chaque publicité
	rewarded_ad_loader = RewardedAdLoader.new()

	var ad_request := AdRequest.new()
	var callback := create_rewarded_ad_load_callback()

	rewarded_ad_loader.load(
		TEST_REWARDED_ID,
		ad_request,
		callback
	)


func show_rewarded_ad() -> void:
	if rewarded_ad == null:
		print("Aucune publicité récompensée disponible.")
		return

	var listener := OnUserEarnedRewardListener.new()
	listener.on_user_earned_reward = _on_user_earned_reward

	rewarded_ad.show(listener)


func is_rewarded_available() -> bool:
	return rewarded_ad != null


func _on_user_earned_reward(rewarded_item: RewardedItem) -> void:
	if reward_callback.is_valid():
		reward_callback.call()

	reward_callback = Callable()


func _on_rewarded_ad_dismissed() -> void:
	print("REWARDED : publicité fermée")

	if rewarded_ad != null:
		rewarded_ad.destroy()
		rewarded_ad = null

	rewarded_availability_changed.emit(false)

	load_rewarded_ad()


func _on_rewarded_ad_failed_to_show(error: AdError) -> void:
	print("REWARDED : échec de l'affichage : ", error)

	if rewarded_ad != null:
		rewarded_ad.destroy()
		rewarded_ad = null

	rewarded_availability_changed.emit(false)

	load_rewarded_ad()


func show_rewarded_ad_with_callback(callback: Callable) -> void:
	reward_callback = callback
	show_rewarded_ad()
