```mermaid
classDiagram
    class GameManager {
        +String GameState
        +Int PlayerScore
        +Int EnemyScore
        +VerificarCaiguda()
        +Respawn(entitat)
        +FinalitzarPartida()
    }

    class Combatant {
        +Instance HumanoidRootPart
        +Int Vides
        +Bool IsAttacking
        +Atacar()
        +RebreImpacte(direccio, forca)
        +RestringirEix()
    }

    class Arena {
        +Float DeathZoneHeight
        +VerificarLimits(posicio)
    }

    class Jugador {
        +InputHandler()
    }

    class Enemic {
        +AI_Logic()
    }

    %% Relacions
    GameManager "1" *-- "2" Combatant : gestiona
    GameManager o-- Arena : consulta límits
    Combatant <|-- Jugador : hereta
    Combatant <|-- Enemic : hereta
```mermaid