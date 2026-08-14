# E1-1 개발 워크스테이션

## 프로젝트 개요

터미널, Docker, Git을 사용해 재현 가능한 개발 환경을 구성한 과제입니다.
NGINX 웹 서버 이미지를 직접 빌드하고 포트, 바인드 마운트, Docker 볼륨을 검증했습니다.

## 실행 환경

- OS: Windows 10
- Shell: PowerShell 5.1
- Docker: 29.7.2 (Docker Desktop / WSL2)
- Git: 2.54.0.windows.1
- Mac에서는 Docker Desktop 또는 OrbStack으로 같은 `docker` 명령을 사용할 수 있습니다.

[환경 확인 전체 로그](evidence/logs/01-environment.txt)

```powershell
docker --version
# Docker version 29.7.2

docker info
# Server Version: 29.7.2

git --version
# git version 2.54.0.windows.1
```

## 파일 구조

```text
E1-1/
├── app/index.html          # 웹 화면
├── bind-demo/index.html    # 바인드 마운트 실습 파일
├── nginx/default.conf      # NGINX 설정과 /health 응답
├── evidence/               # 명령 로그와 스크린샷
├── Dockerfile
└── README.md
```

핵심 파일은 `Dockerfile`, `app/index.html`, `nginx/default.conf` 세 개뿐입니다.

## 수행 체크리스트

- [x] 터미널 파일·디렉터리 조작
- [x] 파일과 디렉터리 권한 변경
- [x] Docker 버전과 데몬 확인
- [x] hello-world 및 Ubuntu 컨테이너 실행
- [x] 이미지·컨테이너·로그·리소스 확인
- [x] Dockerfile 커스텀 이미지 빌드
- [x] 포트 매핑과 브라우저 접속
- [x] 바인드 마운트 변경 반영
- [x] Docker 볼륨 데이터 영속성
- [x] Git 설정과 GitHub 연동

## 1. 터미널 조작

```bash
pwd                    # 현재 위치
ls -la                 # 숨김 파일 포함 목록
mkdir practice         # 디렉터리 생성
cd practice            # 이동
touch note.txt         # 빈 파일 생성
echo hello > note.txt  # 내용 작성
cat note.txt            # 내용 확인
cp note.txt copy.txt   # 복사
mv copy.txt moved.txt  # 이동/이름 변경
rm moved.txt           # 삭제
cd ..
rmdir practice
```

[실제 터미널 조작 로그](evidence/logs/02-terminal-operations.txt)

### 절대 경로와 상대 경로

- 절대 경로: 시작 위치와 관계없는 전체 주소. 예: `/home/user/project`
- 상대 경로: 현재 위치 기준 주소. 예: `./project`, `../project`

## 2. 권한 실습

```bash
chmod 600 permission-file.txt
# -rw------- 600

chmod 644 permission-file.txt
# -rw-r--r-- 644

chmod 700 permission-dir
# drwx------ 700

chmod 755 permission-dir
# drwxr-xr-x 755
```

[권한 변경 전체 로그](evidence/logs/03-permissions.txt)

- `r=4`: 읽기
- `w=2`: 쓰기
- `x=1`: 실행 또는 디렉터리 진입
- `755`: 소유자 `rwx`, 그룹과 기타 사용자 `r-x`
- `644`: 소유자 `rw-`, 그룹과 기타 사용자 `r--`

## 3. Docker 기본 점검과 운영

```bash
docker --version
docker info
docker run --name e1-hello hello-world
docker images
docker ps
docker ps -a
docker logs e1-hello
docker stats --no-stream e1-hello
```

hello-world 결과:

```text
Hello from Docker!
This message shows that your installation appears to be working correctly.
```

[Docker 운영 전체 로그](evidence/logs/04-hello-world-and-operations.txt)

Ubuntu 컨테이너:

```bash
docker run -it --name e1-ubuntu ubuntu bash
ls
echo "hello from ubuntu"
exit

docker start e1-ubuntu
docker exec e1-ubuntu echo "exec runs in a running container"
```

- `attach`: 컨테이너의 기본 프로세스 화면에 연결합니다.
- `exec`: 실행 중인 컨테이너 안에서 새 명령을 실행합니다.
- 기본 프로세스가 끝나면 컨테이너도 종료됩니다.

[Ubuntu 실습 로그](evidence/logs/05-ubuntu-container.txt)

## 4. 커스텀 이미지

사용한 베이스 이미지는 `nginx:alpine`입니다.

```dockerfile
FROM nginx:alpine
COPY nginx/default.conf /etc/nginx/conf.d/default.conf
COPY app/index.html /usr/share/nginx/html/index.html
EXPOSE 80
```

커스텀한 부분은 웹 문서와 NGINX 설정을 교체한 것입니다.

```bash
docker build -t e1-workstation-web:1.0 .
docker run -d --name e1-workstation-web -p 8080:80 e1-workstation-web:1.0
docker ps
docker logs e1-workstation-web
curl http://localhost:8080
```

접속 주소: `http://localhost:8080`

- 호스트의 8080 포트를 컨테이너의 80 포트에 연결했습니다.
- 포트 매핑이 없으면 호스트 브라우저가 컨테이너의 웹 서버에 직접 접근할 수 없습니다.

[빌드·포트·로그 결과](evidence/logs/06-build-port-health.txt)
[브라우저 접속 스크린샷](evidence/screenshots/port-mapping-8080.png)

## 5. 바인드 마운트

```powershell
docker run -d --name e1-bind-web -p 8081:80 --mount type=bind,source="$PWD/bind-demo",target=/usr/share/nginx/html,readonly nginx:alpine
```

호스트의 `bind-demo/index.html`을 수정한 뒤 다시 접속하면 이미지 재빌드 없이 내용이 바뀝니다.

[변경 전·후 비교 로그](evidence/logs/07-bind-mount.txt)

## 6. Docker 볼륨

```bash
docker volume create e1-workstation-data

docker run --name volume-writer --mount source=e1-workstation-data,target=/data alpine sh -c "echo persistent-data > /data/result.txt"
docker rm volume-writer
docker run --rm --mount source=e1-workstation-data,target=/data alpine cat /data/result.txt

# persistent-data
```

첫 컨테이너를 삭제해도 두 번째 컨테이너에서 같은 파일을 읽을 수 있습니다.
볼륨 데이터는 컨테이너가 아니라 Docker가 별도로 관리하기 때문입니다.

[볼륨 삭제 전·후 로그](evidence/logs/08-volume-persistence.txt)

## 7. Git과 GitHub

```bash
git config --global user.name "juhyulee"
git config --global user.email "GitHub noreply 주소"
git config --global init.defaultBranch main
git config --list
git remote -v
```

[Git 설정과 원격 저장소 로그](evidence/logs/10-git-config-and-remote.txt)
[VSCode GitHub 연동 스크린샷](evidence/screenshots/vscode-git-integration.png)

- Git: 내 컴퓨터에서 변경 이력을 관리하는 도구
- GitHub: Git 저장소를 원격에서 공유하고 협업하는 서비스

## 트러블슈팅

### 1. Docker Desktop의 WSL 오류

- 문제: Docker 실행 중 `wsl.exe --version` 오류가 발생했습니다.
- 원인 가설: Windows의 WSL 구성 또는 재부팅이 완료되지 않았습니다.
- 확인: `wsl --status`와 Docker Desktop 실행 상태를 확인했습니다.
- 해결: WSL 설치·업데이트 후 재부팅하고 Docker Desktop을 다시 실행했습니다.

### 2. 포트가 이미 사용 중인 경우

- 문제: `-p 8080:80` 실행 시 포트 사용 오류가 날 수 있습니다.
- 원인 가설: 기존 컨테이너나 다른 프로그램이 8080 포트를 사용 중입니다.
- 확인: `docker ps`로 포트와 컨테이너를 확인합니다.
- 해결: 기존 컨테이너를 중지하거나 `-p 8082:80`처럼 다른 호스트 포트를 사용합니다.

## 이미지·컨테이너·볼륨 차이

- 이미지: 컨테이너를 만드는 읽기 전용 설계도
- 컨테이너: 이미지를 실행한 격리 환경
- 바인드 마운트: 호스트 파일을 컨테이너에 직접 연결
- 볼륨: Docker가 관리하는 영속 데이터 저장소

## 평가 때 설명할 핵심

1. Dockerfile은 NGINX 이미지에 내 HTML과 설정을 복사합니다.
2. `-p 8080:80`은 내 컴퓨터의 8080을 컨테이너 80과 연결합니다.
3. 바인드 마운트는 호스트 파일 변경을 바로 반영합니다.
4. 볼륨은 컨테이너를 삭제해도 데이터를 유지합니다.
5. Git은 로컬 이력, GitHub는 원격 공유 서비스입니다.

## 보안

토큰, 비밀번호, 개인키는 저장소에 포함하지 않았습니다. Git 이메일은 GitHub noreply 주소를 사용했습니다.
