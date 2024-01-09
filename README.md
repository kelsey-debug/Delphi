#  Delphi Dream App


What is Delphi?
A dream analysis app that engages users to explore their sleeping consciousness and
apply newfound wisdom to their waking lives.Delphi combines AI technology with the
works of Freud, Jung and Adler.


How does Delphi work?
Delphi combines an LLM trained on vectors of dream psychology in order to customize queries and responses to be relevant to dream analysis. Delphis diction is customized to help a user understand their dreams without sounding overly profesional. 
Pasted image 20231030103901.png

What technology is used?
Customized ChatGPT3-ADA model
Pinecone Vectors 
Swift, particulary declarative SwiftUI using MVVM design principles 


To build and run: 
All resources keys must be personally added in the config.xcconfig file. A safe way to do this is to have an env file with the  keys and the project scheme run a script that populates the enviroment variables in the xcconfig upon building. The script then takes these values from xcconfig and populates the related plists.  
Demo: 
