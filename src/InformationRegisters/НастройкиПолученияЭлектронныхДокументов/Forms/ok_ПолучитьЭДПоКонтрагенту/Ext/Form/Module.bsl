﻿//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-04-09 (#4120)
&НаКлиенте
Процедура ВыбратьПериод(Команда)
	
	ПараметрыВыбора = Новый Структура("НачалоПериода,КонецПериода", ДатаНачала, ДатаКонца);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериода", ПараметрыВыбора, Элементы.ВыбратьПериод, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДатаНачала = РезультатВыбора.НачалоПериода;
	ДатаКонца = РезультатВыбора.КонецПериода;
		
КонецПроцедуры
//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-04-09 (#4120)

&НаКлиенте
Процедура КомандаВыполнить(Команда)
	 
	ТекстОшибки = "";
	
	Если Не ЗначениеЗаполнено(ДатаНачала) Или Не ЗначениеЗаполнено(ДатаКонца) Тогда
		ТекстОшибки = "Заполните период";
	ИначеЕсли ДатаНачала > ДатаКонца Тогда
		ТекстОшибки = "Период указан не корректно: начало периода больше даты окончания";
	КонецЕсли;
	
	Если ПустаяСтрока(ТекстОшибки) Тогда
		ТекстОшибки = ПроверитьДатуПоПрофилюНастроекЭДО(Параметры.ИдентификаторОрганизации, ДатаКонца);
	КонецЕсли;
	
	Если Не ПустаяСтрока(ТекстОшибки) Тогда
		//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-04-09 (#4120)
		//ОбщегоНазначенияСлужебныйКлиентСервер.СообщитьПользователю(ТекстОшибки, Неопределено, Неопределено);
		ПоказатьПредупреждение(,ТекстОшибки);
		//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-04-09 (#4120) 
		Возврат;
	КонецЕсли;
	
	СтруктураПолей = Новый Структура;
	СтруктураПолей.Вставить("ИдентификаторКонтрагента", Параметры.ИдентификаторКонтрагента);
	СтруктураПолей.Вставить("ИдентификаторОрганизации", Параметры.ИдентификаторОрганизации);
	СтруктураПолей.Вставить("Контрагент",				Параметры.Контрагент);
	СтруктураПолей.Вставить("Организация",				Параметры.Организация);
	СтруктураПолей.Вставить("ДатаС",					ДатаНачала);
	СтруктураПолей.Вставить("ДатаПо",			        ДатаКонца);
	
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("СтруктураДляПолученияЭДПоКонтрагенту", 			СтруктураПолей);
	СтруктураОтбора.Вставить("ЭтоРЗ",			        						Ложь);
	СтруктураОтбора.Вставить("МассивПакетовЭД",									Новый Массив);
	//ОКЕЙ Бублик А.А.(СофтЛаб) Начало 2020-10-02 (#3879)
	СтруктураОтбора.Вставить("ок_ПолучениеДокументовЭДОПоКонтрагентуЗаПериод",	ПроверитьПолучениеДокументовЭДОПоКонтрагентуЗаПериод());
	//ОКЕЙ Бублик А.А.(СофтЛаб) Конец 2020-10-02 (#3879)
	
	ПолучитьНовыеЭлектронныеДокументы(СтруктураОтбора);
	
КонецПроцедуры

//ОКЕЙ Бублик А.А.(СофтЛаб) Начало 2020-10-02 (#3879
&НаСервереБезКонтекста
Функция ПроверитьПолучениеДокументовЭДОПоКонтрагентуЗаПериод()
	
	ок_ПолучениеДокументовЭДОПоКонтрагентуЗаПериод = бит_ПраваДоступа.ПолучитьЗначениеДопПраваПользователя(
	 					                           бит_ОбщиеПеременныеСервер.ЗначениеПеременной("ТекущийПользователь"),
	 					                           ПланыВидовХарактеристик.бит_ДополнительныеПраваПользователей.ок_ПолучениеДокументовЭДОПоКонтрагентуЗаПериод);
												   
	Возврат ок_ПолучениеДокументовЭДОПоКонтрагентуЗаПериод;
	
КонецФункции
//ОКЕЙ Бублик А.А.(СофтЛаб) Конец 2020-10-02 (#3879

&НаСервереБезКонтекста
Функция ПроверитьДатуПоПрофилюНастроекЭДО(ИдентификаторОрганизации, ДатаКонца)
	
	ТекстОшибки = "";
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СостоянияОбменовЭДЧерезОператоровЭДО.ДатаПолученияЭД <= &ДатаКонца КАК ПроверкаДатыПолученияЭД,
		|	СостоянияОбменовЭДЧерезОператоровЭДО.ДатаПолученияЭД КАК ДатаПолученияЭД
		|ИЗ
		|	РегистрСведений.СостоянияОбменовЭДЧерезОператоровЭДО КАК СостоянияОбменовЭДЧерезОператоровЭДО
		|ГДЕ
		|	СостоянияОбменовЭДЧерезОператоровЭДО.ИдентификаторОрганизации = &ИдентификаторОрганизации";
	
	Запрос.УстановитьПараметр("ДатаКонца", ДатаКонца);
	Запрос.УстановитьПараметр("ИдентификаторОрганизации", ИдентификаторОрганизации);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если Не РезультатЗапроса.Пустой() Тогда
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		ВыборкаДетальныеЗаписи.Следующий();
		Если ВыборкаДетальныеЗаписи.ПроверкаДатыПолученияЭД Тогда
			ТекстОшибки = "Необходимо указать дату меньше " + ВыборкаДетальныеЗаписи.ДатаПолученияЭД;
		КонецЕсли;
	Иначе
		ТекстОшибки = "Не удалось найти настроку в РС Состояния обменов ЭД через операторов ЭДО по Идентификатору организации " + ИдентификаторОрганизации;
	КонецЕсли;
	
	Возврат ТекстОшибки;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ПолучитьНовыеЭлектронныеДокументы(СтруктураОтбора)
	
	ок_ОбменСКонтрагентамиВнутренний.ок_ПолучениеНовыхПакетовЭД(СтруктураОтбора);
	Если СтруктураОтбора.МассивПакетовЭД.Количество() > 0 Тогда
		ок_ОбменСКонтрагентамиВнутренний.ок_РаспаковкаПакетовЭД(СтруктураОтбора);
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ок_ИнформацияПоРегламентномуЗаданию.НаименованиеРЗ КАК НаименованиеРЗ,
		|	ок_ИнформацияПоРегламентномуЗаданию.КоличествоОбъектов КАК КоличествоОбъектов,
		|	ок_ИнформацияПоРегламентномуЗаданию.КоличествоОбъектовСОшибками КАК КоличествоОбъектовСОшибками,
		|	ок_ИнформацияПоРегламентномуЗаданию.ЕстьОшибки КАК ЕстьОшибки,
		|	ок_ИнформацияПоРегламентномуЗаданию.КоличествоОшибокВсего КАК КоличествоОшибокВсего
		|ИЗ
		|	РегистрСведений.ок_ИнформацияПоРегламентномуЗаданию КАК ок_ИнформацияПоРегламентномуЗаданию
		|ГДЕ
		|	ок_ИнформацияПоРегламентномуЗаданию.Период >= &Период
		|	И ок_ИнформацияПоРегламентномуЗаданию.ДатаОкончания <= &ДатаОкончания
		|	И ок_ИнформацияПоРегламентномуЗаданию.Пользователь = &Пользователь
		|	И ок_ИнформацияПоРегламентномуЗаданию.НомерСеанса = &НомерСеанса";
	
	Запрос.УстановитьПараметр("ДатаОкончания", 	СтруктураОтбора.ДатаОкончания);
	Запрос.УстановитьПараметр("НомерСеанса", 	НомерСеансаИнформационнойБазы());
	Запрос.УстановитьПараметр("Период", 		СтруктураОтбора.ДатаНачалаРЗ);
	Запрос.УстановитьПараметр("Пользователь", 	ПараметрыСеанса.ТекущийПользователь);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	РезультатВыполнения 	= "Выполнено успешно";
	ТекстПоПолученным		= "";
	ТекстПоРаспакованным 	= "";
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Если ВыборкаДетальныеЗаписи.ЕстьОшибки Тогда
			РезультатВыполнения = "Выполнено с ошибками";
		КонецЕсли;
		Если ВыборкаДетальныеЗаписи.НаименованиеРЗ = Метаданные.РегламентныеЗадания.ок_ПолучениеНовыхПакетовЭД.Синоним Тогда
			ТекстПоПолученным = "Загружено " + ВыборкаДетальныеЗаписи.КоличествоОбъектов + " пакетов ЭД";
			Если ВыборкаДетальныеЗаписи.ЕстьОшибки Тогда
				ТекстПоПолученным = ТекстПоПолученным + Символы.ПС + "Ошибки при загрузке пакетов ЭД " + ВыборкаДетальныеЗаписи.КоличествоОшибокВсего;
			КонецЕсли;
		ИначеЕсли ВыборкаДетальныеЗаписи.НаименованиеРЗ = Метаданные.РегламентныеЗадания.ок_РаспаковкаПакетовЭД.Синоним Тогда
			ТекстПоРаспакованным = "Распаковано " + ВыборкаДетальныеЗаписи.КоличествоОбъектов + " пакетов ЭД";
			Если ВыборкаДетальныеЗаписи.ЕстьОшибки Тогда
				ТекстПоРаспакованным = ТекстПоРаспакованным + Символы.ПС + "Не распаковано или распаковано с ошибками " + ВыборкаДетальныеЗаписи.КоличествоОбъектовСОшибками;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	ИтоговоеСообщение = РезультатВыполнения + Символы.ПС + ТекстПоПолученным + Символы.ПС + ТекстПоРаспакованным + ?(РезультатВыполнения = "Выполнено с ошибками", Символы.ПС + "За дополнительной информацией обратитесь в техподдержку ОКЕЙ", "");
	
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ИтоговоеСообщение);
	
КонецПроцедуры