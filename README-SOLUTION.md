the first step is to set up the repository and run the code locally, in order to do that, i have set up the venv for that to manage that. Additionally I added the default github .gitignore file

Had some issues with the python version and the requirements. Did some searching with Claude and Google to resolve that. the main issue is  pytorch package since i'm on Mac and going through the documentation, for that specific issue and the +cpu versions don't seem to be there for m1 macs. After some searching, I narrowed that the python version to 3.9 - 3.11 range. Since I couldn't resolve the build locally, I'll just run it in a container. Apparently conda is smart enough to handle it, haven't tried it so I'll just use a container.

To build the image, I used the example dockerfile in docker docs. Added the extra env vars except for the one that's resolved during runtime. Resolved a couple of version conflicts, and added gcc because the build was failing for psutils.

Added a run for the fastapi command pip install. The image can be refined further with the new BuildKit to utilize the pip cache but is good enough for now.
