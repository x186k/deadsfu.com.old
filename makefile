

# no
# X=root@143.198.138.184
# we dont use vars so cut and paste to shell works better

all: deploy

ansible:
	ansible-playbook -i ansible-inventory.yml ansible-deploy.yml

serve:
	gojekyll server

restart:
	ssh root@143.198.138.184 docker restart caddy
	
deploy:
	rm -rf _site
	gojekyll build
	ssh root@143.198.138.184 mkdir -p /root/public
	rsync -ar --del _site/ root@143.198.138.184:/root/public
	tar czf - --exclude xplaceholder . | ssh root@143.198.138.184 "cat > /root/public/deadsfu.com.tgz"
	ssh root@143.198.138.184 ls -l /root/public/deadsfu.com.tgz


# update the deadsfu repo by hand, and forget the fancy shit
## git --git-dir=../deadsfu/.git --work-tree=../deadsfu commit -m 'deadsfu.com update' README.md
## @status=$$(git --git-dir=../deadsfu/.git --work-tree=../deadsfu --staged); \
## if [ ! -z "$${status}" ]; \
## then \
## 		echo "Error - deadsfu has staged work, will not push the readme, please do it later"; \
## 		exit 1; \
## fi
## git --git-dir=../deadsfu/.git --work-tree=../deadsfu push









