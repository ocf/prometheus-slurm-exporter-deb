SLURM_EXPORTER_TAG := 0.5

.PHONY: build-image
build-image:
	docker build -t slurm-exporter-build .

.PHONY: package_%
package_%: build-image
	mkdir -p "dist_$*"
	docker run -e "SLURM_EXPORTER_TAG=${SLURM_EXPORTER_TAG}" \
		-e "DIST_TAG=$*" \
		--user $(shell id -u ${USER}):$(shell id -g ${USER}) \
		-v $(CURDIR)/dist_$*:/mnt:rw \
		slurm-exporter-build

.PHONY: clean
clean:
	rm -rf dist_*

.PHONY: test
test: ;
