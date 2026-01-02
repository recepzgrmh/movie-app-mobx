# movie-app-mobx

A Flutter **case-study scaffold** for a TMDB Movie App.

> Current status: **project structure + dependencies set up** (no features implemented yet).

## Goals
- Provide a solid starter for:
  - **Clean Architecture** (Data / Domain / Presentation)
  - **MobX** state management
  - **TMDB API** integration
  - Resilience patterns (errors, retries, timeouts, etc.)

## Current Progress
- [x] Folder structure created (`app / core / features`)
- [x] Dependencies added
- [ ] TMDB networking layer
- [ ] Feature implementations (splash, onboarding, paywall, home)
- [ ] Flavors: dev / staging / prod
- [ ] Paywall A/B variants

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

## Planned
- Build flavors (**dev / staging / prod**)
- Paywall with **A/B testing variants**
- Offline/cache strategy
- CI + basic tests

## Notes
This repository currently contains the **architecture skeleton**.
Implementation will be added incrementally.