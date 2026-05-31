# Fase 6: Validació i Finalització

## Objectius
- Depuració d'errors (debugging) final.
- Optimització del rendiment.
- Documentació i lliurament del projecte.

## Proves de validació (QA)
| Escenari | Resultat Esperat | Estat |
| :--- | :--- | :--- |
| Mort del jugador | Aparició del menú de selecció | [OK] |
| Selecció dificultat | Canvi de velocitat i knockback de l'NPC | [OK] |
| Sortida del joc | Neteja correcta de l'entitat Boss | [OK] |

## Optimitzacions aplicades
* **Neteja de memòria**: Implementació de `Destroy()` per evitar acumulació d'objectes al `Workspace`.
* **Seguretat**: Verificació que només el servidor gestiona els canvis de dificultat.

## Conclusió
El joc compleix amb tots els requisits funcionals definits inicialment. El sistema de combat està equilibrat i el cicle de vida del joc (inici -> combat -> mort -> reinici) és estable.

## Lliurament
- [x] Codi font netejat i comentat.
- [x] Documentació tècnica actualitzada.