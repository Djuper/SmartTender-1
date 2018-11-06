*** Keywords ***
Підтвердити повідомлення про умови проведення аукціону
    ${status}  Run Keyword And Return Status  Wait Until Page Contains  Чи погоджуєтесь Ви з умовами проведення аукціону?
    Run Keyword If  '${status}' == 'True'  Run Keywords
    ...  Click Element  xpath=//button[@class="btn btn-success"]
    ...  AND  Wait Until Element Is Not Visible  xpath=//button[@class="btn btn-success"]


Отримати посилання на аукціон учасником
    [Arguments]  ${role}
    Switch Browser  ${role}
	Дочекатись дати закінчення періоду прийому пропозицій
    Wait Until Keyword Succeeds  10m  20s  Отримати посилання на участь в аукціоні
	Wait Until Keyword Succeeds  10m  20s  Перейти та перевірити сторінку участі в аукціоні  ${data['auctionUrl']}


Подати пропозицію учасниками
    [Arguments]  ${role}
    Switch Browser  ${role}
	wait until keyword succeeds  20m  30s  Перевірити статус тендера  Прийом пропозицій
	Sleep  3m
    Перевірити кнопку подачі пропозиції
	Заповнити поле з ціною  1  1
    Додати файл  1
	Підтвердити відповідність
	Подати пропозицію
    Go Back


Перевірити статус тендера
    [Arguments]  ${tender status}
    Reload Page
    Wait Until Element Is Visible  //*[@data-qa="status"]  20
    ${status}  Get Text  //*[@data-qa="status"]
    Should Be Equal  '${status}'  '${tender status}'


Отримати посилання на участь в аукціоні
	Reload Page
	log to console  Отримати посилання на участь в аукціоні
	debug
	Натиснути кнопку  До аукціону
	Натиснути кнопку  Взяти участь в аукціоні
	${auction_href}  Отримати посилання
	Set To Dictionary  ${data}  auctionUrl  ${auction_href}


Натиснути кнопку
	[Arguments]  ${text}
	${selector}  Set Variable  //button[@type="button" and contains(., "${text}")]
	Wait Until Page Contains Element  ${selector}
	Click Element  ${selector}


Отримати посилання
	${selector}  Set Variable  //a[@href and contains(., "До аукціону")]
	Wait Until Page Contains Element  ${selector}  60
	${auction_href}  Get Element Attribute  ${selector}  href
	[Return]  ${auction_href}


Перевірити можливість отримати посилання на аукціон користувачем
	[Arguments]  ${role}
	Switch Browser  ${role}
	Reload Page
	Run Keyword And Expect Error  *  Отримати посилання на участь в аукціоні


Перейти та перевірити сторінку участі в аукціоні
	[Arguments]  ${auction_href}
	Go To  ${auction_href}
	Підтвердити повідомлення про умови проведення аукціону
	Wait Until Page Contains Element  //*[@class="page-header"]//h2  30
	Location Should Contain  bidder_id=
	Sleep  2
	Element Should Contain  //*[@class="page-header"]//h2  ${data['tender_uaid']}
	Element Should Contain  //*[@class="lead ng-binding"]  ${data['title']}
	Element Should Contain  //*[contains(@ng-repeat, 'items')]  ${data['item']['description']}
	Element Should Contain  //*[contains(@ng-repeat, 'items')]  ${data['item']['quantity']}
	Element Should Contain  //*[contains(@ng-repeat, 'items')]  ${data['item']['unit']}
	Element Should Contain  //h4  Вхід на даний момент закритий.