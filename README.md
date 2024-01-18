# Delphi Dream App

[!NOTE] This app is a WIP and at its minimal viable product stage. 

## What is Delphi?

A dream analysis app that engages users to explore their sleeping consciousness and apply newfound wisdom to their waking lives. Delphi combines AI technology with the research works of Freud, Jung and Adler.
 I created this app as a fun way to experiment with the new AI open source world,and make something I would use myself.

linkedin: 
https://www.linkedin.com/in/kelsey-larson-039ba4200/


## How does Delphi work?
Delphi combines an LLM with vector data of dream psychology in order to customize queries and responses to be relevant to dream analysis. Delphis diction is customized to engage the user, using an approachable tone that doesnt lean on technical psychology jargon. It avoids an overly formal and rigid language to encourage a curious, casual conversation. 

![image](https://github.com/kelsey-debug/DelphiPub/assets/57580796/c22be628-362e-4feb-ace3-2a2e8d4e9d78)


## What technology is used?
- ChatGPT3-ADA model, customized with pinecone training data
- Pinecone Vectors 
- Swift, particulary declarative SwiftUI using MVVM design principles 
- Use of 3rd party open source libs such as LangChain swift 


> [!IMPORTANT] 
To build and run, all resource keys must be personally added in the config.xcconfig file. Inside the pre-build work for the Delphi scheme, a script exists to pull key-value sources from an .env file and populate the .xcconfig and the associated plists.  I suggest you populate your .env like so: 

```
OPENAI_API_KEY= yourkey
OPENAI_ORGANIZATION= yourorg

SIMPLE_SLASH=/

PINECONE_KEY= yourkey
PINCONE_BASE_URL=yoururl 

AUTH0_DOMAIN=domain
AUTH0_CLIENT_ID=clientid
```

This allows the script to pull your key values and populate the associated plists appropriately without exposing them in the code. ~~Obviously~~, dont push your env file with keys to public git spaces. :octocat:


A safe way to do this is to have an env file with the keys and the project scheme run a script that populates the enviroment variables in the xcconfig upon building. The script then takes these values from xcconfig and populates the related plists. 
## Demo: 


