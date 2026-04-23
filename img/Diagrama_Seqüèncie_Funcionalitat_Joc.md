```mermaid
sequenceDiagram
    participant J as Jugador
    participant S as Script d'Atac (Luau)
    participant P as Motor Físic (Roblox)
    participant E as Enemic
    participant GM as GameManager

    J->>S: Prem botó d'atac (F / Clic)
    S->>P: Raycast / Detecció de proximitat
    P-->>S: Retorna impacte = cert
    
    rect rgb(200, 220, 255)
        Note over S, E: Inici de resposta física
        S->>E: Crida RebreImpacte()
        E->>P: ApplyImpulse(direcció)
        P->>E: Mou posició física
    end

    GM->>P: Consulta Posició Y
    P-->>GM: Posició Y < DeathZoneHeight
    
    GM->>GM: Restar Vida
    GM->>E: Respawn()
```mermaid
