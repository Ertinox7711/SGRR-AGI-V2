# Audio manifest — the part of the libraries that is NOT in git

Every audio file of every library is listed here with its size and SHA-256, so the
set is complete on paper even though the bytes are not in the repo. Why they are out:
GitHub **rejects** any single file over 100 MB, and one replay
(`69_REDIF_11-05-26_Google_Gateway.mp3`, 104.7 MB) is over that line — so a plain
`git push` of this folder cannot succeed. Git LFS would take it, but the free tier is
1 GB of storage and 1 GB of bandwidth per month against 3.36 GB here.

**Almost none of the content is lost.** Nearly every replay ships its own written
transcript in `B-ecom-boss-transcripts/` — the words are in the repo, only the voice
is not. `scripts/add-audio.ps1` puts the audio back, either from a local copy or by
turning on Git LFS.

| # | library | file | size | sha256 |
|--:|---|---|--:|---|
| 1 | `A-inner-circle` | `_audio/7oHqk2amrAA9pkxvbue00qFkHqgdDh0000GxUwY2UUdoIM.mp3` | 39.7 MB | `cc703ebdd6549ee8…` |
| 2 | `A-inner-circle` | `_audio/IQXFcg8M9fIgFg32YG7X4tYY1LxTicZCsVt9g4CtLV8.mp3` | 30.1 MB | `03b94d6d136ed607…` |
| 3 | `A-inner-circle` | `_audio/SC8p02HD00Pf8WpRxpPsm9wMLeUNXwscxSjo01F64o82100.mp3` | 27.4 MB | `550e04b05e3e28a3…` |
| 4 | `A-inner-circle` | `_audio/TA6oSE123002mMHQpgPLdGEasLCrRMCXtbEJcfkPiqF00.mp3` | 33.4 MB | `1a3ab3d533d4b30d…` |
| 5 | `A-inner-circle` | `appels-arthur/2026-07-27-appel-arthur/appel-arthur-2026-07-27.mp3` | 13.0 MB | `864058813ac7f04e…` |
| 6 | `B-ecom-boss-transcripts` | `_audio/01_REDIF_12-01-25_AGENT_Shipping_Revolution.mp3` | 28.0 MB | `ca8f1a83f31bd23f…` |
| 7 | `B-ecom-boss-transcripts` | `_audio/02_REDIF_26-01-25_CRO_avec_Louis.mp3` | 76.3 MB | `4d431452c8304f8f…` |
| 8 | `B-ecom-boss-transcripts` | `_audio/03_REDIF_10-02-25_Emailing_Klaviyo_Rayan.mp3` | 43.3 MB | `645f115de55f7510…` |
| 9 | `B-ecom-boss-transcripts` | `_audio/04_REDIF_18-02-25_expert_GMC_Sebastien.mp3` | 60.6 MB | `6233deda643bcff1…` |
| 10 | `B-ecom-boss-transcripts` | `_audio/05_REDIF_24-02-25_Feedcast_Geoffrey.mp3` | 29.1 MB | `7e1d8352af1dcf13…` |
| 11 | `B-ecom-boss-transcripts` | `_audio/06_REDIF_03-03-25_GG_Ads_Maxime.mp3` | 72.1 MB | `cd5a6be3b7794e23…` |
| 12 | `B-ecom-boss-transcripts` | `_audio/07_REDIF_10-03-25_Expert_Copywriting_Tristan.mp3` | 45.9 MB | `ea48a4b023c8709d…` |
| 13 | `B-ecom-boss-transcripts` | `_audio/08_REDIF_20-03-25_Live_Special_Debutants.mp3` | 65.9 MB | `4a743f813c5446f7…` |
| 14 | `B-ecom-boss-transcripts` | `_audio/09_REDIF_24-03-25.mp3` | 49.3 MB | `87ad53249d22c06e…` |
| 15 | `B-ecom-boss-transcripts` | `_audio/10_REDIF_31-03-25.mp3` | 28.6 MB | `d040d862e6350aad…` |
| 16 | `B-ecom-boss-transcripts` | `_audio/11_REDIF_07-04-25.mp3` | 44.7 MB | `3cf04aa585337378…` |
| 17 | `B-ecom-boss-transcripts` | `_audio/12_REDIF_21-04-25.mp3` | 58.8 MB | `fc6afd4cc3ccef56…` |
| 18 | `B-ecom-boss-transcripts` | `_audio/13_REDIF_28-04-25.mp3` | 70.0 MB | `6dbdd58c55366504…` |
| 19 | `B-ecom-boss-transcripts` | `_audio/14_REDIF_05-05-25.mp3` | 68.2 MB | `9c5c23173ea67cf3…` |
| 20 | `B-ecom-boss-transcripts` | `_audio/15_REDIF_12-05-25.mp3` | 51.4 MB | `0e8f6309f750847f…` |
| 21 | `B-ecom-boss-transcripts` | `_audio/16_redif_190525_live_bundle_avec_mat_de_sousa.mp3` | 26.8 MB | `f562be59c79d6ba5…` |
| 22 | `B-ecom-boss-transcripts` | `_audio/17_redif_270525_live_copyfy_avec_thomas_salic.mp3` | 14.7 MB | `eaee961cecc952d8…` |
| 23 | `B-ecom-boss-transcripts` | `_audio/18_redif_020625.mp3` | 24.6 MB | `30eb71f43d18e265…` |
| 24 | `B-ecom-boss-transcripts` | `_audio/19_redif_120625_live_baptistin.mp3` | 16.5 MB | `66f4505f7d84571f…` |
| 25 | `B-ecom-boss-transcripts` | `_audio/20_redif_180625_live_spécial_high_ticket.mp3` | 27.5 MB | `473c2497e04a48a3…` |
| 26 | `B-ecom-boss-transcripts` | `_audio/21_intro_séminaire_intervention_de_manoah.mp3` | 19.8 MB | `8d0a8da7906c5cc7…` |
| 27 | `B-ecom-boss-transcripts` | `_audio/22_intervention_de_manoah.mp3` | 9.6 MB | `2d38ab11ad0884ab…` |
| 28 | `B-ecom-boss-transcripts` | `_audio/23_redif_300625.mp3` | 14.6 MB | `7a94ab5ed379ded7…` |
| 29 | `B-ecom-boss-transcripts` | `_audio/24_redif_070725_live_expatriation_avec_el_rayhan.mp3` | 28.4 MB | `249fd7116e9aae13…` |
| 30 | `B-ecom-boss-transcripts` | `_audio/25_redif_140725.mp3` | 28.4 MB | `6f4f1c0dd11f4fe6…` |
| 31 | `B-ecom-boss-transcripts` | `_audio/26_redif_240725.mp3` | 9.9 MB | `64ec1c639a1bfabd…` |
| 32 | `B-ecom-boss-transcripts` | `_audio/27_redif_040825.mp3` | 21.0 MB | `cca6e67d551e01a6…` |
| 33 | `B-ecom-boss-transcripts` | `_audio/28_redif_110825_live_mailing_avec_rayan.mp3` | 19.5 MB | `8e2fc58ec7a79037…` |
| 34 | `B-ecom-boss-transcripts` | `_audio/29_redif_170825.mp3` | 26.9 MB | `1ee59b0795239a78…` |
| 35 | `B-ecom-boss-transcripts` | `_audio/30_redif_030925.mp3` | 27.5 MB | `b76149f8f8b788e5…` |
| 36 | `B-ecom-boss-transcripts` | `_audio/31_redif_160925.mp3` | 29.5 MB | `6660d7088cbd17d0…` |
| 37 | `B-ecom-boss-transcripts` | `_audio/32_redif_230925_live_optimisation_fiscale_wlouis.mp3` | 21.4 MB | `6abcc8df40c336de…` |
| 38 | `B-ecom-boss-transcripts` | `_audio/33_redif_290925.mp3` | 28.0 MB | `8fc8884d7c1b587b…` |
| 39 | `B-ecom-boss-transcripts` | `_audio/34_redif_071025.mp3` | 28.1 MB | `99d6875c8018e83a…` |
| 40 | `B-ecom-boss-transcripts` | `_audio/35_redif_111025_live_scaling.mp3` | 27.9 MB | `4f31f6a8a9dcb94b…` |
| 41 | `B-ecom-boss-transcripts` | `_audio/36_redif_201025_live_avec_arthur_expatrié_à_19_ans.mp3` | 33.6 MB | `16bab96842a7f431…` |
| 42 | `B-ecom-boss-transcripts` | `_audio/37_redif_271025.mp3` | 37.0 MB | `a34eabb88b0e0e4d…` |
| 43 | `B-ecom-boss-transcripts` | `_audio/38_redif_031125_live_avec_enzo_2kday.mp3` | 34.3 MB | `abe30bdf3de3ce98…` |
| 44 | `B-ecom-boss-transcripts` | `_audio/39_redif_101125.mp3` | 26.4 MB | `5707925e98b7a1d0…` |
| 45 | `B-ecom-boss-transcripts` | `_audio/40_redif_191125.mp3` | 27.3 MB | `ebdc66f8a14bbbb1…` |
| 46 | `B-ecom-boss-transcripts` | `_audio/41_redif_251125.mp3` | 27.8 MB | `955a2d25273454df…` |
| 47 | `B-ecom-boss-transcripts` | `_audio/42_REDIF_01-12-25_expert_Google.mp3` | 63.5 MB | `e2f09f651de6a4bb…` |
| 48 | `B-ecom-boss-transcripts` | `_audio/43_redif_081225_live_uprank_expert_geo_et_seo.mp3` | 29.4 MB | `e5df8fb4d33bb82b…` |
| 49 | `B-ecom-boss-transcripts` | `_audio/44_redif_151225.mp3` | 45.1 MB | `d514d9b9e1bb1b7a…` |
| 50 | `B-ecom-boss-transcripts` | `_audio/45_redif_201225.mp3` | 53.7 MB | `519ca1009ee08af0…` |
| 51 | `B-ecom-boss-transcripts` | `_audio/46_redif_050126.mp3` | 41.5 MB | `22bd9575b530ca03…` |
| 52 | `B-ecom-boss-transcripts` | `_audio/47_REDIF_13-01-26_GMC_Tristan.mp3` | 99.5 MB | `fd6a3ad63a47906f…` |
| 53 | `B-ecom-boss-transcripts` | `_audio/48_REDIF_17-01-26_SEO_Google_Tristan.mp3` | 96.1 MB | `46a05fc662ff470d…` |
| 54 | `B-ecom-boss-transcripts` | `_audio/49_REDIF_24-01-26_Google_Ads.mp3` | 70.1 MB | `0af535afde516d54…` |
| 55 | `B-ecom-boss-transcripts` | `_audio/50_redif_260126_live_whatsapp_marketing.mp3` | 18.7 MB | `4e7400010f20d9a0…` |
| 56 | `B-ecom-boss-transcripts` | `_audio/51_redif_310126.mp3` | 38.1 MB | `c1cb9bb4cd9373cf…` |
| 57 | `B-ecom-boss-transcripts` | `_audio/52_redif_070226.mp3` | 27.7 MB | `3655c8b8113f278a…` |
| 58 | `B-ecom-boss-transcripts` | `_audio/53_redif_140226.mp3` | 55.1 MB | `ab1361f53cbd050e…` |
| 59 | `B-ecom-boss-transcripts` | `_audio/54_redif_160226.mp3` | 40.2 MB | `b5cb9dab4d42f731…` |
| 60 | `B-ecom-boss-transcripts` | `_audio/55_redif_200226.mp3` | 29.7 MB | `a0566e3e78344823…` |
| 61 | `B-ecom-boss-transcripts` | `_audio/56_redif_230226.mp3` | 53.3 MB | `de79f75bb3341ee7…` |
| 62 | `B-ecom-boss-transcripts` | `_audio/57_redif_270226_questions_réponses.mp3` | 51.3 MB | `4354bdadb06fd0f3…` |
| 63 | `B-ecom-boss-transcripts` | `_audio/58_redif_100326.mp3` | 49.9 MB | `76179033002edeb2…` |
| 64 | `B-ecom-boss-transcripts` | `_audio/59_redif_130326.mp3` | 75.9 MB | `179867be076a44a1…` |
| 65 | `B-ecom-boss-transcripts` | `_audio/60_redif_230326.mp3` | 44.3 MB | `74aac979bf5b8cf3…` |
| 66 | `B-ecom-boss-transcripts` | `_audio/61_redif_030426.mp3` | 33.5 MB | `249c855645092c29…` |
| 67 | `B-ecom-boss-transcripts` | `_audio/62_redif_080426.mp3` | 28.0 MB | `e7b93bcd382bab74…` |
| 68 | `B-ecom-boss-transcripts` | `_audio/63_redif_100426.mp3` | 33.6 MB | `ca7dc6ab1bcb01e8…` |
| 69 | `B-ecom-boss-transcripts` | `_audio/64_redif_150426.mp3` | 51.8 MB | `de03c73db5d14d28…` |
| 70 | `B-ecom-boss-transcripts` | `_audio/65_redif_220426.mp3` | 57.6 MB | `638f515dcf29ed60…` |
| 71 | `B-ecom-boss-transcripts` | `_audio/66_redif_280426.mp3` | 55.6 MB | `e0a16ab60c794389…` |
| 72 | `B-ecom-boss-transcripts` | `_audio/67_redif_010526_live_experts_ia.mp3` | 44.6 MB | `5fa44fab01902758…` |
| 73 | `B-ecom-boss-transcripts` | `_audio/68_redif_060526.mp3` | 53.4 MB | `2d959d651801c0ac…` |
| 74 | `B-ecom-boss-transcripts` | `_audio/69_REDIF_11-05-26_Google_Gateway.mp3` | 104.7 MB | `8eb8685db0b71ba5…` |
| 75 | `B-ecom-boss-transcripts` | `_audio/70_redif_130526.mp3` | 57.0 MB | `8502b30dc37cf179…` |
| 76 | `B-ecom-boss-transcripts` | `_audio/71_redif_150526.mp3` | 29.9 MB | `b479b45308c91287…` |
| 77 | `B-ecom-boss-transcripts` | `_audio/72_redif_200526.mp3` | 52.2 MB | `8eedd834128f79ea…` |
| 78 | `B-ecom-boss-transcripts` | `_audio/73_redif_300526.mp3` | 46.4 MB | `0aac294ece4aa295…` |
| 79 | `B-ecom-boss-transcripts` | `_audio/74_redif_050626.mp3` | 49.2 MB | `657657e42cad87b4…` |
| 80 | `B-ecom-boss-transcripts` | `_audio/75_redif_080626.mp3` | 62.7 MB | `a2689ba706890f2e…` |
| 81 | `B-ecom-boss-transcripts` | `_audio/76_redif_110626.mp3` | 65.3 MB | `0979898e775360e0…` |
| 82 | `B-ecom-boss-transcripts` | `_audio/77_redif_150626.mp3` | 62.3 MB | `1d97ea36e90ae255…` |

**82 files, 3.36 GB.**
