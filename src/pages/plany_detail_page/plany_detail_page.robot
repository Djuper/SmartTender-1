*** Keywords ***
Порівняти назву плану
	[Arguments]  ${text}
	Location Should Contain  /publichni-zakupivli-prozorro-plany/
	Select Frame  css=iFrame
	${title}  Get Text  css=#main-section .title-plan
	Should Be Equal  ${title}  ${text}
	Unselect Frame