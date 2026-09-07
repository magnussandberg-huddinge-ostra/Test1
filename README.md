# Linux Network Lab – GitHub Codespaces

Det här repot är ett färdigt nätverkslabb för undervisning i Linux och nätverksadministration.

Varje elev startar en egen GitHub Codespace från repot. Inuti Codespace startas flera separata Ubuntu-miljöer med Docker Compose på samma privata nätverk.

## Labbet

| Maskin | Hostname | IP-adress | Roll |
|---|---|---:|---|
| Klient | `client` | `172.20.0.10` | Linux-klient |
| Server 1 | `server1` | `172.20.0.20` | Linux-server, t.ex. webbserver |
| Server 2 | `server2` | `172.20.0.30` | Linux-server, t.ex. DNS-server |
| Backupserver | `backupserver` | tilldelas automatiskt först | Elevövning: statisk IP, SSH och backup |

Nät: `172.20.0.0/24`

De tre färdiga maskinerna har användaren `student` och lösenordet `student` för det isolerade labbnätet. Backupservern är avsiktligt inte färdigkonfigurerad.

## Starta i Codespaces

1. Öppna repot på GitHub.
2. Klicka **Code**.
3. Välj **Codespaces**.
4. Klicka **Create codespace on main**.
5. När terminalen öppnas, kör:

```bash
./scripts/lab-start.sh
```

Kontrollera maskinerna:

```bash
./scripts/lab-status.sh
```

## Logga in på en färdig maskin

Direkt via Docker:

```bash
docker exec -it server1 bash
```

Som användaren `student`:

```bash
docker exec -it -u student server1 bash
```

SSH från klienten:

```bash
docker exec -it client bash
ssh student@172.20.0.20
```

Lösenord: `student`

## Testa nätverket

Från `client`:

```bash
ping -c 4 172.20.0.20
ping -c 4 172.20.0.30
```

Visa nätverksinställningar:

```bash
ip addr
ip route
```

## Laboration: Gör backupservern klar

Backupservern startar med en automatiskt tilldelad adress och utan installerad SSH-server. Uppgiften är att konfigurera den.

### 1. Gå in på backupservern

Från Codespace-terminalen:

```bash
docker exec -it backupserver bash
```

Kontrollera aktuell adress:

```bash
ip addr
```

### 2. Sätt fast IP-adress

Backupservern ska få:

```text
172.20.0.40/24
```

Börja med att ta reda på nätverkskortets namn med `ip addr`. Sätt sedan adressen på rätt interface. Exempel om interfacet heter `eth0`:

```bash
ip addr flush dev eth0
ip addr add 172.20.0.40/24 dev eth0
ip link set eth0 up
```

Kontrollera:

```bash
ip addr
ping -c 4 172.20.0.10
```

### 3. Gör servern klar för SSH

Installera SSH-server:

```bash
apt update
apt install openssh-server -y
```

Sätt ett lösenord för användaren `student`:

```bash
passwd student
```

Starta SSH:

```bash
service ssh start
```

Kontrollera:

```bash
service ssh status
ss -tulpn
```

### 4. Testa från klienten

Öppna klienten:

```bash
docker exec -it client bash
```

Testa först nätverket:

```bash
ping -c 4 172.20.0.40
```

Anslut sedan:

```bash
ssh student@172.20.0.40
```

När detta fungerar är backupservern färdig för nästa moment: backup med `scp`, `rsync`, `tar` och senare schemaläggning.

## Första laboration med server1

1. Starta labbet.
2. Kontrollera IP-adresserna.
3. Pinga mellan klient och servrar.
4. SSH från `client` till `server1`.
5. Installera Nginx på `server1`:

```bash
sudo apt update
sudo apt install nginx -y
sudo service nginx start
```

6. Testa från `client`:

```bash
curl http://172.20.0.20
```

7. Undersök öppna portar på servern:

```bash
ss -tulpn
```

## Stoppa labbet

```bash
./scripts/lab-stop.sh
```

## Återställ labbet

```bash
./scripts/lab-reset.sh
```

Ändringar som bara gjorts inne i containrarna försvinner vid full återställning. Backupservern har en separat Docker-volume monterad på `/backups` för senare backupövningar.

## Backup av elevarbete

Filer som sparas i Git-repot kan versionshanteras:

```bash
git add .
git commit -m "Spara mitt arbete"
git push
```
