

# no
# X=root@165.227.51.131
# we dont use vars so cut and paste to shell works better

all: deploy

serve:
	docker run --rm -it -v $(CURDIR):/srv/jekyll -p 4000:4000 -p 35729:35729 jekyll/builder:4.2.0 jekyll serve --livereload


restart:
	ssh root@165.227.51.131 docker restart caddy
	
deploy:
	rm -rf _site
	docker run --rm -it -v $(CURDIR):/srv/jekyll jekyll/builder:4.2.0 jekyll build
	ssh root@165.227.51.131 mkdir -p /root/public
	rsync -ar --del _site/ root@165.227.51.131:/root/public
	tar czf - --exclude xplaceholder . | ssh root@165.227.51.131 "cat > /root/public/deadsfu.com.tgz"
	ssh root@165.227.51.131 ls -l /root/public/deadsfu.com.tgz
	cp index.md ../deadsfu/README.md

# update the deadsfu repo by hand, and forget the fancy shit
## git --git-dir=../deadsfu/.git --work-tree=../deadsfu commit -m 'deadsfu.com update' README.md
## @status=$$(git --git-dir=../deadsfu/.git --work-tree=../deadsfu --staged); \
## if [ ! -z "$${status}" ]; \
## then \
## 		echo "Error - deadsfu has staged work, will not push the readme, please do it later"; \
## 		exit 1; \
## fi
## git --git-dir=../deadsfu/.git --work-tree=../deadsfu push





ansible-setup:
	ansible-playbook -i ansible-inventory.yml ansible-deploy.yml



