ifneq ("$(wildcard .env)", "")
include .env
export
default: tunnel
else
CONFIGURE=1
SERVER=example.com
USER=root
REMOTE_PORT=8000
LOCAL_PORT=8000
default: configure tunnel
endif

.PHONY: configure jenkins jenkins-log jenkins-exec tunnel tunnel-log log kill list

configure:
	@echo This in an one-time initial set up.
	@echo
	@echo -n "Remote server: (default is $(SERVER)) " \
	&& read SERVER && echo SERVER=$${SERVER:-$(SERVER)} > .env \
	&& echo -n "Remote user: (default is $(USER)) " \
	&& read USER && echo USER=$${USER:-$(USER)} >> .env \
	&& echo -n "Remote port: (default is $(REMOTE_PORT)) " \
	&& read REMOTE_PORT && echo REMOTE_PORT=$${REMOTE_PORT:-$(REMOTE_PORT)} >> .env \
	&& echo -n "Local port: (default is $(LOCAL_PORT)) " \
	&& read LOCAL_PORT && echo LOCAL_PORT=$${LOCAL_PORT:-$(LOCAL_PORT)} >> .env \
	&& echo \
	&& echo Current content in .env: \
	&& cat .env \
	&& echo Settings are saved in the .env-file \
	&& echo

# Create new tunnel setup from .env-file
tunnel:
	@bash tunnel-setup.sh $(LOCAL_PORT) $(USER) $(SERVER) $(REMOTE_PORT) >> /dev/null
	@echo Created tunnel from localhost:$(LOCAL_PORT) to $(USER)@$(SERVER):$(REMOTE_PORT)
	@echo
	@echo Current tunnels:
	@ps aux | grep 'ssh -o ExitOn' | grep -v 'grep' | awk '{print "PID: "$$2"   RtoL: "$$22"   SERVER: "$$23}'

# Show autossh log file
tunnel-log:
	@less /tmp/autossh.log

# Use: make kill filter={server}
id?=some-id
kill:
	@PIDS=$$(ps aux | grep 'ssh -o ExitOn' | grep $(filter) | grep -v 'grep' | awk '{print $$2}') \
	&& if [ -n "$$PIDS" ]; then kill $$PIDS; fi

# Use: make killall
killall:
	@PIDS=$$(ps aux | grep 'ssh -o ExitOn' | grep ssh | grep -v 'grep' | awk '{print $$2}') \
	&& if [ -n "$$PIDS" ]; then kill $$PIDS; fi

switchto:
	@cp .env.$(config) .env
	@echo Replaced .env with .env.$(config)

# List current SSH connections
list:
	@ps aux | grep 'ssh -o ExitOn' | grep -v 'grep' | awk '{print "PID: "$$2"   RtoL: "$$22"   SERVER: "$$23}'
