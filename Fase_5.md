# Fase 5: Implementació i Integració

## Objectius
- Integració dels mòduls desenvolupats a les fases anteriors.
- Proves de comunicació entre Client i Servidor.
- Ajust de físiques i comportaments en temps real.

## Tasques realitzades
* **Connexió Remota**: Implementació dels `RemoteEvents` per a la sincronització de la dificultat i l'inici del joc.
* **Integració de l'IA**: Ajust final de la lògica de seguiment de l'NPC (`MoveTo` loop).
* **Gestió d'estats**: Implementació del sistema de reset (`GameOver`) per garantir un cicle de joc continu.

## Resultats
- [ ] El sistema de combat (tecla F) respon correctament.
- [ ] La comunicació client-servidor s'estableix sense latència perceptible.
- [ ] L'NPC segueix el jugador de forma fluida i sense bloquejos.

## Problemes detectats i solucions
1. **Problema**: L'NPC moria a l'aparèixer.
   - **Solució**: Afegit un `task.wait(1)` i desplaçament del `SpawnLocation`.
2. **Problema**: El menú no es reiniciava.
   - **Solució**: Implementació de la funció `ShowMenu` vinculada a l'esdeveniment de mort.