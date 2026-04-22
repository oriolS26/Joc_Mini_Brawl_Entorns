# Fase 1: Explora la idea i delimita l’abast

**Nom del fitxer:** Fase_1.md  
**Projecte:** Roblox Mini Brawl

---

## 1. Títol provisional del joc
**Roblox Mini Brawl**

## 2. Tipus de microvideojoc escollit
Joc de lluita 3D amb perspectiva fixa i moviment restringit (estil *Super Smash Bros* o *Sumo*). Es tracta d'un combat en una plataforma on la física és la mecànica principal.

## 3. Objectiu del joc
L'objectiu principal és fer fora l'enemic de la plataforma de combat. No es busca reduir una barra de vida mitjançant mal (damage) tradicional, sinó utilitzar la força dels impactes per empènyer l'adversari al buit.

## 4. Rol del jugador
El jugador controla un personatge en tercera persona amb les següents capacitats:
* **Moviment lateral:** Desplaçament a l'esquerra i a la dreta (Eix X).
* **Salt:** Capacitat per esquivar atacs o reposicionar-se.
* **Atac bàsic:** Un moviment que genera un impuls físic (*Knockback*) en el contrincant.
* **Gestió d'eix:** El jugador s'ha de preocupar de no caure mentre intenta expulsar l'altre.

## 5. Regles bàsiques
* **Límit de l'escenari:** Si un personatge surt dels marges de la plataforma i cau per sota d'una alçada determinada (ex: -50 studs), perd una vida.
* **Física d'impacte:** Cada atac aplicat amb èxit genera una força instantània (`ApplyImpulse`) proporcional a la direcció de l'atac.
* **Sistema de vides:** Cada combatent comença amb un comptador de 3 vides.
* **Respawn:** En perdre una vida, el personatge reapareix al centre de la plataforma si encara té vides restants.

## 6. Condicions de victòria i derrota
* **Victòria:** L'enemic (IA) perd les seves 3 vides en caure al buit.
* **Derrota:** El jugador perd les seves 3 vides en caure al buit.

## 7. Bucle principal del joc (Game Loop)
1.  **Posicionament:** El jugador i la IA busquen una distància òptima.
2.  **Acció d'atac:** El jugador prem el botó d'atac.
3.  **Detecció de col·lisió:** El sistema verifica mitjançant un script si l'atac ha connectat amb l'oponent.
4.  **Aplicació de força:** Si hi ha impacte, s'aplica el *knockback*.
5.  **Verificació d'estat:** El sistema comprova si algú ha caigut. Si és així, es resta vida i es reinicia la posició.
6.  **Repetició:** El cicle continua fins que un dels dos comptadors arriba a zero.

## 8. Repte principal i dificultat
* **Repte:** El domini del *timing* i de la inèrcia. En ser un joc basat en física, el jugador ha de preveure el moviment per no "passar-se de frenada" i caure ell mateix en atacar.
* **Dificultat prevista:** Mitjana-Baixa. La IA serà un perseguidor simple, el que fa que el joc sigui fàcil d'entendre però difícil de dominar per la inestabilitat de la plataforma.

## 9. Limitacions explícites (Fora de l'abast)
Per garantir el lliurament en 10 hores, **NO** s'inclourà:
* Animacions de personatges complexes (s'usaran blocs o moviments rígids).
* Efectes de so o música ambiental.
* Sistema de partícules o efectes visuals especials.
* Multijugador en línia (serà Jugador vs. IA local).
* Múltiples personatges o selecció de poders.

## 10. Riscos tècnics
1.  **Restricció del moviment en 2D:** Impedir que els personatges es desplacin per l'eix Z (profunditat) en un motor natiu 3D pot generar conflictes amb les col·lisions de Roblox.
2.  **Estabilitat de la IA:** Una IA massa simple podria caure sola de la plataforma constantment si no es calculen bé els marges.
3.  **Sincronització Rojo-Studio:** Possibles errors en el servidor de sincronització que podrien aturar el flux de treball entre VS Code i Roblox.

## 11. Exploració amb IA
* **Prompt 1:** *"Com puc restringir el moviment d'un Humanoid a Roblox Studio perquè només es mogui en els eixos X i Y, ignorant el Z?"*
    * **Resum resposta:** Es recomana usar `RunService.Heartbeat` per forçar la propietat `Position.Z` a un valor fix o utilitzar un `LinearVelocity` per bloquejar l'eix.
* **Prompt 2:** *"Quin és el mètode més eficient en Luau per aplicar una força d'empenta (knockback) a un altre jugador?"*
    * **Resum resposta:** L'ús de `HumanoidRootPart:ApplyImpulse()` és el mètode més modern i eficient, ja que treballa directament amb el motor físic de Roblox sense necessitar instàncies de *BodyVelocity* antigues.

## 12. Proposta final escollida
Es confirma la creació de **Roblox Mini Brawl**: un prototip funcional de lluita de plataformes centrat en la física, utilitzant Rojo per a la gestió de codi i GitHub per al control de versions.

## 13. Justificació de viabilitat
El projecte és viable en 10 hores perquè:
1.  **Motor Físic:** Roblox ja gestiona la gravetat i les col·lisions; només cal aplicar forces puntuals.
2.  **Codi:** Luau permet una prototipació extremadament ràpida de la lògica de vides i respawn.
3.  **Abast:** En eliminar animacions i sons, tot el temps es dedica a la funcionalitat pura del bucle de joc.

## 14. Mini pla de treball
* **Fase 1 (1.5h):** Definició, configuració de Rojo, Git i entorn de treball. (Actual)
* **Fase 2 (2h):** Configuració de l'escenari, càmera fixa i script de restricció d'eix Z.
* **Fase 3 (2h):** Mecànica d'atac i sistema de *knockback*.
* **Fase 4 (2h):** Lògica de la IA (perseguir i atacar) i sistema de vides/mort.
* **Fase 5 (1.5h):** Creació de la interfície (GUI) de vides i poliment de la física.
* **Fase 6 (1h):** Proves finals, correcció de bugs i tancament de la documentació.

## 15. Eines previstes i justificació
* **Roblox Studio:** Motor de joc que ja inclou el servidor, el renderitzat i la física.
* **Visual Studio Code:** Editor extern per programar amb més velocitat i connectors de Git.
* **Rojo:** Eina indispensable per connectar el codi de VS Code amb Roblox Studio.
* **Git/GitHub:** Per garantir el control de versions i la seguretat del codi.
* **Luau:** Llenguatge de programació optimitzat per al motor de Roblox.