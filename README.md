# Linux Network Lab – GitHub Codespaces

Det här repot är ett färdigt nätverkslabb för undervisning i Linux och nätverksadministration.

Varje elev startar en egen GitHub Codespace från repot. Inuti Codespace startas tre separata Ubuntu-miljöer med Docker Compose på samma privata nätverk.

## Labbet

| Maskin | Hostname | IP-adress | Roll |
|---|---|---:|---|
| Klient | `client` | `172.20.0.10` | Linux-klient |
| Server 1 | `server1` | `172.20.0.20` | Linux-server, t.ex. webbserver |
| Server 2 | `server2` | `172.20.0.30` | Linux-server, t.ex. DNS-server |

Nät: `172.20.0.0/24`

Användare i alla tre maskiner:

- användarnamn: `student`
- lösenord: `student`

Lösenordet används bara i det isolerade labbnätet. SSH-portarna publiceras inte mot internet.

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

## Logga in på en maskin

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

## Första laboration

1. Starta alla tre Linuxmaskiner.
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

Detta tar bort labbmaskinerna och skapar rena maskiner igen:

```bash
./scripts/lab-reset.sh
```

**Varning:** ändringar som bara gjorts inne i containrarna försvinner vid återställning. Spara dokumentation, skript och viktiga filer i repot.

## Backup av elevarbete

Filer som sparas i Git-repot kan versionshanteras:

```bash
git add .
git commit -m "Spara mitt arbete"
git push
```
