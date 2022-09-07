#!/bin/bash

package:
	ls charts | xargs -I@ helm package --destination='docs/@' 'charts/@'

repo: package
	helm repo index docs
