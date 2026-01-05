# movie-app-mobx

A Flutter **case-study** TMDB Movie App built with **Clean Architecture + MobX**.

## Demo
📽️ **application.mp4:** [Watch / Download](./application.mp4)

<video src="./application.mp4" controls muted playsinline style="max-width: 20%;"></video>

## Completed
- [x] Clean Architecture (Data / Domain / Presentation)
- [x] MobX state management (Stores)
- [x] DI with GetIt
- [x] Networking (Dio + interceptors)
- [x] Navigation (GoRouter)
- [x] Splash: fetch popular movies + genres + paywall config (parallel)
- [x] Onboarding: movie selection + infinite scroll
- [x] Onboarding: genre selection logic
- [x] Paywall: A/B variants supported via config
- [x] Home: “For You” + category feed
- [x] Home: Spy-scroll (sticky tabs synced with scroll position)

## To Do (Bonus Challenges)
- [ ] Flavors: **dev / staging / prod** (separate entrypoints + icons + endpoints)
- [ ] CI/CD documentation (README improvements)

## Project Structure
```
lib/
├─ app/
│  ├─ config/
│  ├─ di/
│  └─ router/
├─ core/
│  ├─ network/
│  ├─ error/
│  ├─ result/
│  ├─ theme/
│  └─ widgets/
└─ features/
   ├─ splash/
   │  ├─ data/
   │  ├─ domain/
   │  └─ presentation/
   ├─ onboarding/
   │  ├─ data/
   │  ├─ domain/
   │  └─ presentation/
   ├─ paywall/
   │  ├─ data/
   │  ├─ domain/
   │  └─ presentation/
   └─ home/
      ├─ data/
      ├─ domain/
      └─ presentation/

``` 