﻿&НаКлиенте
Перем КонтекстЭДОКлиент Экспорт;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Элементы.ГруппаГоризонтальнаяЭтапа2.Видимость = Ложь;
	
	Источник          = Параметры.Источник;
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	
	ИнициализироватьПараметры(Источник, КонтекстЭДОСервер);
	СформироватьТабДок(КонтекстЭДОСервер);
	ЕстьСоглашениеСПФР = КонтекстЭДОСервер.ОрганизацияПодключенаКЭДОсПФР(Организация); 
	УправлениеФормой(ЭтотОбъект);
	
	//Чтобы для тестовой учетной записи возвращались данные, должно быть так:
	//КодРегиона = "77";
	//КодПФР = "099-099";

	Если ЗначениеЗаполнено(КодРегиона) И ЗначениеЗаполнено(КодПФР) Тогда
		НачатьОпределениеКонтактовПФР();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПоказатьНаКартеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	УправлениеКонтактнойИнформациейКлиент.ПоказатьАдресНаКарте(
		Элементы.АдресУПФР.Заголовок,
		"ЯндексКарты");
	
КонецПроцедуры
	
&НаКлиенте
Процедура ПояснениеПоПодключениюКПФРОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "Заявление" Тогда
		
		КонтекстЭДОКлиент.НапечататьДокумент(ТабДокЗаявления, НСтр("ru = 'Заявление о подключении к электронному документообороту'"), Истина);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "Сайт" Тогда
		
		Если ЗначениеЗаполнено(СсылкаНаСоглашение) Тогда
			ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(СсылкаНаСоглашение);
		Иначе
			ТабДокСоглашения = ТабДокСоглашенияСПФР();
			КонтекстЭДОКлиент.НапечататьДокумент(ТабДокСоглашения, НСтр("ru = 'Соглашение об обмене эл. документами с ПФР'"), Истина);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СформироватьТабДок(КонтекстЭДОСервер)
	
	// Заявление
	ТабДокЗаявления = СформироватьЗаявлениеПФР();
	
	// Соглашение
	ПараметрыПодключенияКПФР = КонтекстЭДОСервер.ПараметрыПодключенияКПФР(КодРегиона);
	СсылкаНаСоглашение       = ПараметрыПодключенияКПФР.Ссылка;
	
	Если НЕ ЗначениеЗаполнено(СсылкаНаСоглашение) Тогда
		ТабДокСоглашения = ТабДокСоглашенияСПФР();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьПараметры(Источник, КонтекстЭДОСервер)
	
	Если ТипЗнч(Источник) = Тип("ДокументСсылка.ЗаявлениеАбонентаСпецоператораСвязи") И ЗначениеЗаполнено(Источник) Тогда
		
		Заявление  = Источник;
		КодРегиона = КонтекстЭДОСервер.КодРегионаВМастереПоАдресу(Заявление.АдресЮридический);
		
		Для Каждого СтрокаНаправления из Заявление.Получатели цикл 
			Если СтрокаНаправления.ТипПолучателя = Перечисления.ТипыКонтролирующихОрганов.ПФР Тогда
				КодПФР = СтрокаНаправления.КодПолучателя;
			КонецЕсли;
		КонецЦикла;
		
		Организация = Заявление.Организация;
		
	Иначе
		Организация = Источник;
		
		СтруктураРеквизитов = Новый Структура("Организация, КодОрганаПФР, АдресЮридический, ПриОткрытии", Организация);
		СтруктураРеквизитов.ПриОткрытии = Ложь;
		КонтекстЭДОСервер.ЗаполнитьДанныеОрганизации(СтруктураРеквизитов);
		
		КодПФР     = СтруктураРеквизитов.СтруктураДанныхОрганизации.КодОрганаПФР;
		КодРегиона = КонтекстЭДОСервер.КодРегионаВМастереПоАдресу(СтруктураРеквизитов.АдресЮридический);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СформироватьЗаявлениеПФР()
	
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	
	УчетнаяЗапись = КонтекстЭДОСервер.УчетнаяЗаписьОрганизации(Организация);
	
	ДанныеОрганизации = Новый Структура();
	ДанныеОрганизации.Вставить("Организация", Организация);
	ДанныеОрганизации.Вставить("ПриОткрытии", Ложь);
	КонтекстЭДОСервер.ЗаполнитьДанныеОрганизации(ДанныеОрганизации);
	
	Если ЗначениеЗаполнено(УчетнаяЗапись) И НЕ ЗначениеЗаполнено(Заявление) Тогда
		
		ДополнительныеРеквизиты = КонтекстЭДОСервер.ДополнительныеРеквизитыУчетнойЗаписи(УчетнаяЗапись);
		Если ДополнительныеРеквизиты.Количество() > 0 Тогда
			
			Фамилия  = ДополнительныеРеквизиты.ВладелецЭЦПФамилия;
			Имя      = ДополнительныеРеквизиты.ВладелецЭЦПИмя;
			Отчество = ДополнительныеРеквизиты.ВладелецЭЦПОтчество;
			
			ПаспортныеДанные = КонтекстЭДОСервер.ПаспортныеДанныеВладельцаЭП(УчетнаяЗапись);
			
			ВладелецЭЦПСерияДокумента      = ПаспортныеДанные.ВладелецЭЦПСерияДокумента;
			ВладелецЭЦПНомерДокумента      = ПаспортныеДанные.ВладелецЭЦПНомерДокумента;
			ВладелецЭЦПДатаВыдачиДокумента = ПаспортныеДанные.ВладелецЭЦПДатаВыдачиДокумента;
			ВладелецЭЦПКемВыданДокумент    = ПаспортныеДанные.ВладелецЭЦПКемВыданДокумент;
			ВладелецЭЦПКодПодразделения    = ПаспортныеДанные.ВладелецЭЦПКодПодразделения;
			
			ЭтоПаспортРФ = СокрЛП(Строка(ПаспортныеДанные.КодВидаДокумента)) = "21";
			
			КраткоеНаименование = ДополнительныеРеквизиты.КраткоеНаименование;
			КПП                 = ДополнительныеРеквизиты.КПП;
			ИНН                 = ДополнительныеРеквизиты.ИНН;
			ЭлектроннаяПочта    = ДополнительныеРеквизиты.ЭлектроннаяПочта;
			ТелефонОсновной     = ДополнительныеРеквизиты.ТелефонОсновной;
			РегНомерПФР         = ДополнительныеРеквизиты.РегНомерПФР;
			ТипКриптопровайдера	= ДополнительныеРеквизиты.ТипКриптопровайдера;
			
		КонецЕсли;
		
	Иначе
		
		Фамилия  = Заявление.ВладелецЭЦПФамилия;
		Имя      = Заявление.ВладелецЭЦПИмя;
		Отчество = Заявление.ВладелецЭЦПОтчество;
		
		ВладелецЭЦПСерияДокумента      = Заявление.ВладелецЭЦПСерияДокумента;
		ВладелецЭЦПНомерДокумента      = Заявление.ВладелецЭЦПНомерДокумента;
		ВладелецЭЦПДатаВыдачиДокумента = Заявление.ВладелецЭЦПДатаВыдачиДокумента;
		ВладелецЭЦПКемВыданДокумент    = Заявление.ВладелецЭЦПКемВыданДокумент;
		ВладелецЭЦПКодПодразделения    = Заявление.ВладелецЭЦПКодПодразделения;
		
		ЭтоПаспортРФ = ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервера.ЭтоПаспортРФ(Заявление.ВладелецЭЦПВидДокумента);
		
		КраткоеНаименование = Заявление.КраткоеНаименование;
		КПП                 = Заявление.КПП;
		ИНН                 = Заявление.ИНН;
		ЭлектроннаяПочта    = Заявление.ЭлектроннаяПочта;
		ТелефонОсновной     = Заявление.ТелефонОсновной;
		РегНомерПФР         = Заявление.РегНомерПФР;
		ТипКриптопровайдера	= Заявление.ТипКриптопровайдера;
		
	КонецЕсли;
	
	ЭтоЮридическоеЛицо = СтрДлина(ИНН) = 10;
	
	АдресЮридическийПредставление = ДанныеОрганизации.АдресЮридическийПредставление;
	АдресФактическийПредставление = ДанныеОрганизации.АдресФактическийПредставление;

	ДанныеОрганизации = ДанныеОрганизации.СтруктураДанныхОрганизации;
	
	ТабДокумент = Новый ТабличныйДокумент;
	Бланк = КонтекстЭДОСервер.ПолучитьМакетОбработки("ЗаявлениеНаПодключениеКПФР");
	
	// Шапка.
	Шапка = Бланк.ПолучитьОбласть("Шапка");
	Шапка.Параметры["ДатаНачала"] = Формат(ТекущаяДатаСеанса(), "ДЛФ=DD");
	ТабДокумент.Вывести(Шапка);
	
	// Сведения по организации.
	Если ЭтоЮридическоеЛицо Тогда
		
		ОбластьОрганизации = Бланк.ПолучитьОбласть("ЮрЛицо");
		ОбластьОрганизации.Параметры["ПолноеНаименование"] = КраткоеНаименование;
		ОбластьОрганизации.Параметры["КПП"] = КПП;
		
		ОбластьОрганизации.Параметры["ЮрАдрес"] 	= АдресЮридическийПредставление;
		ОбластьОрганизации.Параметры["ФактАдрес"] 	= АдресФактическийПредставление;
		
	Иначе
		
		// Вывод пустой области
		ОбластьОрганизации = Бланк.ПолучитьОбласть("ЮрЛицо");
		ТабДокумент.Вывести(ОбластьОрганизации);
		
		// Вывод заполненной области
		ОбластьОрганизации = Бланк.ПолучитьОбласть("ФизЛицо");
		
		ОбластьОрганизации.Параметры["ФИО"] = Фамилия + " " + Имя + " " + Отчество;
		
		Если ЭтоПаспортРФ Тогда
			
			ОбластьОрганизации.Параметры["Серия"] = ВладелецЭЦПСерияДокумента;
			ОбластьОрганизации.Параметры["НомерПаспорта"] = ВладелецЭЦПНомерДокумента;
			
			Выдан = НСтр("ru = '%1, код подразделения %2, выдан %3'");
			Выдан = СтрШаблон(Выдан,
				ВладелецЭЦПКемВыданДокумент,
				ВладелецЭЦПКодПодразделения,
				Формат(ВладелецЭЦПДатаВыдачиДокумента, "ДФ=dd.MM.yyyy"));
			
			ОбластьОрганизации.Параметры["Выдан"] = Выдан;
			
		КонецЕсли;
		
		ОбластьОрганизации.Параметры["АдресРегистрации"] 	= АдресЮридическийПредставление;
		ОбластьОрганизации.Параметры["АдресПроживания"] 	= АдресФактическийПредставление;
		
	КонецЕсли;
	
	ОбластьОрганизации.Параметры["ИНН"] 			= ИНН;
	ОбластьОрганизации.Параметры["Почта"] 			= ЭлектроннаяПочта;
	ОбластьОрганизации.Параметры["Телефон"] 		= ТелефонОсновной;
	ОбластьОрганизации.Параметры["РегНомерПФР"] 	= РегНомерПФР;
	ОбластьОрганизации.Параметры["КорСчет"] 		= ДанныеОрганизации.БанкСчетКоррСчетБанка;
	ОбластьОрганизации.Параметры["РасчетныйСчет"] 	= ДанныеОрганизации.БанкСчетНомер;
	
	Если ЗначениеЗаполнено(ДанныеОрганизации.БанкСчетБИКБанка) Тогда
		ОбластьОрганизации.Параметры["Банк"] = ДанныеОрганизации.БанкСчетНаимБанка + " БИК " + ДанныеОрганизации.БанкСчетБИКБанка;
	Иначе
		ОбластьОрганизации.Параметры["Банк"] = ДанныеОрганизации.БанкСчетНаимБанка;
	КонецЕсли;
		
	ТабДокумент.Вывести(ОбластьОрганизации);
	
	Если ЭтоЮридическоеЛицо Тогда
		// Вывод пустой области
		ОбластьОрганизации = Бланк.ПолучитьОбласть("ФизЛицо");
		ТабДокумент.Вывести(ОбластьОрганизации);
	КонецЕсли;
	
	// Сведения о СКЗИ
	СКЗИ = Бланк.ПолучитьОбласть("СКЗИ");
	
	СКЗИ.Параметры["Оператор"] = "АО ""Калуга Астрал""";
	
	Если Заявление <> Неопределено И Заявление.ЭлектроннаяПодписьВМоделиСервиса // Это ЭП в облаке
		ИЛИ ТипКриптопровайдера = Перечисления.ТипыКриптоПровайдеров.CryptoPro Тогда
		ПредставлениеКриптопровайдера = КриптографияЭДКОКлиентСервер.КриптопровайдерCryptoPro().Представление;
	Иначе
		ПредставлениеКриптопровайдера = КриптографияЭДКОКлиентСервер.КриптопровайдерViPNet().Представление;
	КонецЕсли;
	СКЗИ.Параметры["СКЗИ"] = ПредставлениеКриптопровайдера;
	
	ТабДокумент.Вывести(СКЗИ);
	
	// Подвал
	Подвал       = Бланк.ПолучитьОбласть("Подвал");
	Руководитель = ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервераПереопределяемый.Руководитель(Организация); 
	Если ЗначениеЗаполнено(Руководитель) Тогда
		ФИОРуководителя = ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервера.ФИОФизЛица(Руководитель);
		ФамилияИнициалыРуководителя = ФизическиеЛицаКлиентСервер.ФамилияИнициалы(ФИОРуководителя);
		Подвал.Параметры["Руководитель"] = ФамилияИнициалыРуководителя;
	КонецЕсли;
	ТабДокумент.Вывести(Подвал);
	
	ТабДокумент.АвтоМасштаб = Истина;
	Возврат ТабДокумент;
	
КонецФункции

&НаСервере
Функция ТабДокСоглашенияСПФР()

	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	
	ТабДокумент   = Новый ТабличныйДокумент;
	Бланк         = КонтекстЭДОСервер.ПолучитьМакетОбработки("СоглашениеПФР");
	УчетнаяЗапись = КонтекстЭДОСервер.УчетнаяЗаписьОрганизации(Организация);
	
	ДанныеОрганизации = Новый Структура();
	ДанныеОрганизации.Вставить("Организация", Организация);
	ДанныеОрганизации.Вставить("ПриОткрытии", Ложь);
	КонтекстЭДОСервер.ЗаполнитьДанныеОрганизации(ДанныеОрганизации);
	
	Если ЗначениеЗаполнено(УчетнаяЗапись) И НЕ ЗначениеЗаполнено(Заявление) Тогда
		
		ДополнительныеРеквизиты = КонтекстЭДОСервер.ДополнительныеРеквизитыУчетнойЗаписи(УчетнаяЗапись);
		Если ДополнительныеРеквизиты.Количество() > 0 Тогда
			
			Фамилия  = ДополнительныеРеквизиты.ВладелецЭЦПФамилия;
			Имя      = ДополнительныеРеквизиты.ВладелецЭЦПИмя;
			Отчество = ДополнительныеРеквизиты.ВладелецЭЦПОтчество;
			КПП      = ДополнительныеРеквизиты.КПП;
			ИНН      = ДополнительныеРеквизиты.ИНН;
			
		КонецЕсли;
		
	Иначе
		
		Фамилия  = Заявление.ВладелецЭЦПФамилия;
		Имя      = Заявление.ВладелецЭЦПИмя;
		Отчество = Заявление.ВладелецЭЦПОтчество;
		КПП      = Заявление.КПП;
		ИНН      = Заявление.ИНН;
		
	КонецЕсли;
	
	ЭтоЮридическоеЛицо = СтрДлина(ИНН) = 10;
	
	АдресЮридическийПредставление = ДанныеОрганизации.АдресЮридическийПредставление;
	АдресЮридическийЗначение      = ДанныеОрганизации.АдресЮридическийЗначение;
	АдресФактическийПредставление = ДанныеОрганизации.АдресФактическийПредставление;

	ДанныеОрганизации  = ДанныеОрганизации.СтруктураДанныхОрганизации;
	ПолноеНаименование = ДанныеОрганизации.НаимЮЛПол;
	РегНомПФР          = ДанныеОрганизации.РегНомПФР;
	
	// РуководительРодПадеж
    ФИО = Новый Массив;
	ФИО.Добавить(Фамилия);
	ФИО.Добавить(Имя);
	ФИО.Добавить(Отчество);
	
	РуководительИмПадеж  = СтрСоединить(ФИО, " "); 
	РуководительРодПадеж = КонтекстЭДОСервер.ОберткаСклонения(РуководительИмПадеж, 2);
	
	ИНН_КПП = Новый Массив;
	ИНН_КПП.Добавить(ИНН);
	ИНН_КПП.Добавить(КПП);
	ИНН_КПП = СтрСоединить(ИНН_КПП, "/"); 
	
	Бланк.Параметры.Дата = Формат(ТекущаяДатаСеанса(), "ДЛФ=D");
	Бланк.Параметры.Город = КонтекстЭДОСервер.ПолеСертификата_2_5_4_7(АдресЮридическийЗначение);
	Бланк.Параметры.ОрганизацияПолноеНаименование = ПолноеНаименование;
	Бланк.Параметры.ИНН_КПП = ИНН_КПП;
	Бланк.Параметры.РуководительИмПадеж = РуководительИмПадеж;
	Бланк.Параметры.РуководительРодПадеж = РуководительРодПадеж;
	Бланк.Параметры.РуководительРодПадеж = РуководительРодПадеж;
	Бланк.Параметры.КорСчет 		= ДанныеОрганизации.БанкСчетКоррСчетБанка;
	Бланк.Параметры.РасчетныйСчет 	= ДанныеОрганизации.БанкСчетНомер;
	Бланк.Параметры.АдресЮридическийПредставление 	= АдресЮридическийПредставление;
	Бланк.Параметры.АдресФактическийПредставление 	= АдресФактическийПредставление;
	Бланк.Параметры.ТекстПредупреждения = ТекстПредупреждения(ЭтотОбъект);
	
	Если ЗначениеЗаполнено(ДанныеОрганизации.БанкСчетБИКБанка) Тогда
		Бланк.Параметры.Банк = ДанныеОрганизации.БанкСчетНаимБанка + " БИК " + ДанныеОрганизации.БанкСчетБИКБанка;
	Иначе
		Бланк.Параметры.Банк = ДанныеОрганизации.БанкСчетНаимБанка;
	КонецЕсли;
	
	ТабДокумент.Вывести(Бланк);
	ТабДокумент.ОбластьПечати = ТабДокумент.Область("ОбластьПечати");
	ТабДокумент.АвтоМасштаб = Истина;
	
	Возврат ТабДокумент;

КонецФункции

&НаСервере
Процедура НачатьОпределениеКонтактовПФР()
	
	АдресЗаданияПоПолучениюКонтактовПФР = ПоместитьВоВременноеХранилище("", ЭтаФорма.УникальныйИдентификатор);
	
	ДополнительныеПараметры = Новый Массив();
	ДополнительныеПараметры.Добавить(АдресЗаданияПоПолучениюКонтактовПФР);
	ДополнительныеПараметры.Добавить(КодРегиона);
	ДополнительныеПараметры.Добавить(КодПФР);
	
	ФоновыеЗадания.Выполнить("ЭлектронныйДокументооборотСКонтролирующимиОрганами.ПолучитьКонтактыПФР", ДополнительныеПараметры);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	
	Если ЗначениеЗаполнено(КодРегиона) И ЗначениеЗаполнено(КодПФР) Тогда
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьПолучениеКонтактовПФР", 0.5, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьПолучениеКонтактовПФР()
	
	Если ЭтоАдресВременногоХранилища(АдресЗаданияПоПолучениюКонтактовПФР) Тогда
			
		Данные = ПолучитьИзВременногоХранилища(АдресЗаданияПоПолучениюКонтактовПФР);
		
		Если ТипЗнч(Данные) = Тип("Структура") И Данные.Выполнено Тогда
			
			НаименованиеУПФР = Данные.Наименование;
			АдресУПФР 		 = Данные.Адрес;
			ТелефонУПФР		 = Данные.Телефон;
			
			ОтключитьОбработчикОжидания("Подключаемый_ПроверитьПолучениеКонтактовПФР");
			
			// В текст подсказки добавляем контакты ПФР
			Если НЕ ЗначениеЗаполнено(СсылкаНаСоглашение) Тогда
				ТабДокСоглашения = ТабДокСоглашенияСПФР();
			КонецЕсли;
			
		Иначе
			ПодключитьОбработчикОжидания("Подключаемый_ПроверитьПолучениеКонтактовПФР", 1, Истина);
		КонецЕсли;
		
	Иначе
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьПолучениеКонтактовПФР", 1, Истина);
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	
	Если ЗначениеЗаполнено(Форма.НаименованиеУПФР) Тогда
		
		Элементы.ГруппаГоризонтальнаяЭтапа2.Видимость = Истина;
		
		Элементы.НаименованиеУПФР.Заголовок = Форма.НаименованиеУПФР;
		Элементы.АдресУПФР.Заголовок 		= Форма.АдресУПФР;
		Элементы.ТелефонУПФР.Заголовок 		= Форма.ТелефонУПФР;
		
	Иначе
		
		Если Элементы.ГруппаГоризонтальнаяЭтапа2.Видимость Тогда
			Элементы.ГруппаГоризонтальнаяЭтапа2.Видимость = Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Форма.СсылкаНаСоглашение) Тогда
		Элементы.Пояснение2Этапа1_2.ОтображениеПодсказки = ОтображениеПодсказки.Нет;
	Иначе
		
		Элементы.Пояснение2Этапа1_2.ОтображениеПодсказки = ОтображениеПодсказки.Кнопка;
		Элементы.Пояснение2Этапа1_2.РасширеннаяПодсказка.Заголовок = ТекстПредупреждения(Форма);
	
	КонецЕсли;
	
	Элементы.Пояснение3Этапа1.Видимость = ЗначениеЗаполнено(Форма.СсылкаНаСоглашение);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ТекстПредупреждения(Форма)
	
	Если ЗначениеЗаполнено(Форма.НаименованиеУПФР) Тогда
		ТекстПредупреждения = НСтр("ru = 'Обратите внимание, на сайте вашего отделения ПФР (%1) не опубликован бланк Соглашения, в связи с чем сформирован федеральный бланк. Рекомендуем заранее уточнить в вашем отделении, возможно ли использование федерального бланка Соглашения. 
                                    |Телефоны отделения: %2.'");
		ТекстПредупреждения = СтрШаблон(ТекстПредупреждения, Форма.НаименованиеУПФР, Форма.ТелефонУПФР);
	Иначе
		ТекстПредупреждения = НСтр("ru = 'Обратите внимание, на сайте вашего отделения ПФР не опубликован бланк Соглашения, в связи с чем сформирован федеральный бланк. Рекомендуем заранее уточнить в вашем отделении, возможно ли использование федерального бланка Соглашения.'");
	КонецЕсли;
	
	Возврат ТекстПредупреждения;
	
КонецФункции

&НаСервере
Процедура УстановитьСостояниеПодключенияКЭДОсПФР(Организация, ОрганизацияПодключена)
	
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	КонтекстЭДОСервер.УстановитьСостояниеПодключенияКЭДОсПФР(Организация, ОрганизацияПодключена); 
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьНастройку(Команда)
	
	УстановитьСостояниеПодключенияКЭДОсПФР(Организация, ЕстьСоглашениеСПФР);
	
	Если Открыта() Тогда
		
		ДополнительныеПараметры = Новый Структура();
		ДополнительныеПараметры.Вставить("ОрганизацияПодключенаКЭДОсПФР", ЕстьСоглашениеСПФР);
		ДополнительныеПараметры.Вставить("Организация", Организация);
		
		Закрыть(ДополнительныеПараметры);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьНастройку(Команда)
	
	Если Открыта() Тогда
		Закрыть();
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти