﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ОплатаПлатежнойКартойФормы.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОплатаПлатежнойКартойКлиент.ПриОткрытии(ЭтотОбъект, Отказ);
	
	Если ПлательщикНПД И ЧекиНПДКлиентСервер.ЧекОжидаетОтправкиВФНС(СведенияОЧекеНПД) Тогда
		ПодключитьОбработчикОжидания("Подключаемый_ОбновитьСтатусОфлайнЧековНПД", 1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Документ.ОплатаПлатежнойКартой.Форма.ФормаВыбора" Тогда
		
		ОплатаПлатежнойКартойКлиент.ДокументОснованиеОбработкаВыбора(ЭтотОбъект, ВыбранноеЗначение);
		
	ИначеЕсли ИсточникВыбора.ИмяФормы = "Документ.ОплатаПлатежнойКартой.Форма.ФормаРасшифровкаПлатежа" Тогда
		
		ОбработкаРасшифровкиПлатежа(ВыбранноеЗначение);
		
	ИначеЕсли ИсточникВыбора.ИмяФормы = "Справочник.Патенты.Форма.ФормаЭлемента" Тогда
		
		ЗаполнитьПатентОбработкаВыбора(ВыбранноеЗначение);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	ОплатаПлатежнойКартойКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);

КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)

	ОплатаПлатежнойКартойКлиентСервер.ЗаполнитьРеквизитыРасшифровкаПлатежа(ЭтотОбъект);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	ОплатаПлатежнойКартойФормы.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	ОплатаПлатежнойКартойФормы.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	ОплатаПлатежнойКартойКлиент.ПослеЗаписи(ЭтотОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	ОплатаПлатежнойКартойКлиент.ОбработкаНавигационнойСсылки(
		ЭтотОбъект, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказатьКонтекстныеНовости(Команда)

	ОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаКомандыНовости(ЭтотОбъект, Команда);

КонецПроцедуры

&НаКлиенте
Процедура АннулироватьЧек(Команда)

	ОплатаПлатежнойКартойКлиент.ВыполнитьАннулированиеЧека(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ПробитьЧекНПД(Команда)
	
	ОплатаПлатежнойКартойКлиент.ПробитьЧекНПД(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуТаблицы()
	
	Отказ = Ложь;
	
	// Проверим, чтобы ключевые поля документы были заполнены, чтобы в дополнительной форме отборы работали корректно.
	Если НЕ ЗначениеЗаполнено(Объект.Дата) Тогда
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Поле", "Заполнение", НСтр("ru = 'Дата'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Дата", "Объект", Отказ);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Поле", "Заполнение", НСтр("ru = 'Организация'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Организация", "Объект", Отказ);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Контрагент) Тогда
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Поле", "Заполнение", НСтр("ru = 'Плательщик'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Контрагент", "Объект", Отказ);
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ТолькоПросмотр Тогда
		ЗаблокироватьДанныеФормыДляРедактирования();
	КонецЕсли;
	
	ОплатаПлатежнойКартойКлиентСервер.ЗаполнитьРеквизитыРасшифровкаПлатежа(ЭтотОбъект);
	
	Шапка = ОплатаПлатежнойКартойКлиентСервер.ИнициализироватьСтруктуруРеквизитовДокумента();
	ЗаполнитьЗначенияСвойств(Шапка, Объект);
	
	ПараметрыФормы = ОплатаПлатежнойКартойКлиентСервер.ИнициализироватьСтруктуруРеквизитовФормы();
	ЗаполнитьЗначенияСвойств(ПараметрыФормы, ЭтотОбъект);
	ПараметрыФормы.Вставить("Шапка", Шапка);
	
	АдресХранилищаРасшифровкаПлатежа = ПоместитьРасшифровкаПлатежаВоВременноеХранилищеНаСервере();
	ПараметрыФормы.Вставить("АдресХранилищаРасшифровкаПлатежа", АдресХранилищаРасшифровкаПлатежа);
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Ключ",           Параметры.Ключ);
	СтруктураПараметров.Вставить("ПараметрыФормы", ПараметрыФормы);
	СтруктураПараметров.Вставить("ТолькоПросмотр", ТолькоПросмотр);
	
	ОткрытьФорму("Документ.ОплатаПлатежнойКартой.Форма.ФормаРасшифровкаПлатежа", СтруктураПараметров, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(Объект.Дата) Тогда
		Возврат;
	КонецЕсли;
	
	Если НачалоДня(Объект.Дата) = НачалоДня(ТекущаяДатаДокумента) Тогда
		// Изменение времени не влияет на поведение документа.
		ТекущаяДатаДокумента = Объект.Дата;
		Возврат;
	КонецЕсли;
	
	// Общие проверки условий по датам.
	ТребуетсяВызовСервера = ОбщегоНазначенияБПКлиент.ТребуетсяВызовСервераПриИзмененииДатыДокумента(Объект.Дата,
		ТекущаяДатаДокумента, Объект.ВалютаДокумента, ВалютаРегламентированногоУчета);
	
	// Если есть договоры в у.е., то необходимо получение курсов валют.
	Если НЕ ТребуетсяВызовСервера Тогда
		ТребуетсяВызовСервера = ЕстьРасчетыВУсловныхЕдиницах;
	КонецЕсли;
		
	// Если определили, что изменение даты может повлиять на какие-либо параметры, 
	// то передаем обработку на сервер.
	Если ТребуетсяВызовСервера Тогда
		ДатаПриИзмененииСервер();
	КонецЕсли;
	
	// Запомним новую дату документа.
	ТекущаяДатаДокумента = Объект.Дата;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидОперацииПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(Объект.ВидОперации) Тогда
		Возврат;
	КонецЕсли;
	
	ВидОперацииПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		Возврат;
	КонецЕсли;
	
	ОрганизацияПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура РасчетыПриОплатеПриИзменении(Элемент)

	Объект.БезЗакрывающихДокументов = РасчетыПриОплате = "БезДокументов";
	ВидОперацииПриИзмененииНаСервере();

КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(Объект.Контрагент) Тогда
		Возврат;
	КонецЕсли;
	
	КонтрагентПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ВидОплатыПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.ВидОплаты) Тогда
		ВидОплатыПриИзмененииНаСервере();
	Иначе
		ОчиститьСвязанныеРеквизиты();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидОплатыОткрытие(Элемент, СтандартнаяОбработка)
	
	Если Объект.ВидОплаты.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыПередачи = Новый Структура;
	
	ДопустимыеТипыОплаты = Новый Массив;
	
	ДопустимыеТипыОплаты.Добавить(ПредопределенноеЗначение("Перечисление.ТипыОплат.ПлатежнаяКарта"));
	ДопустимыеТипыОплаты.Добавить(ПредопределенноеЗначение("Перечисление.ТипыОплат.БанковскийКредит"));
	
	ПараметрыПередачи.Вставить("ТипОплатыДоступныеЗначения", ДопустимыеТипыОплаты);
	ПараметрыПередачи.Вставить("Ключ", Объект.ВидОплаты);
	
	ОткрытьФорму("Справочник.ВидыОплатОрганизаций.ФормаОбъекта", ПараметрыПередачи, ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура СуммаДокументаПриИзменении(Элемент)

	ОплатаПлатежнойКартойКлиент.СуммаДокументаПриИзменении(ЭтотОбъект);
	СуммаДокументаПриИзмененииНаСервере();

КонецПроцедуры

&НаКлиенте
Процедура НадписьРазбитьПлатежНажатие(Элемент)

	ОткрытьФормуТаблицы();

КонецПроцедуры

&НаКлиенте
Процедура НадписьСуммаДокументаНажатие(Элемент, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	ОткрытьФормуТаблицы();

КонецПроцедуры

&НаКлиенте
Процедура НомерЧекаНПДПриИзменении(Элемент)
	
	ОплатаПлатежнойКартойКлиент.НомерЧекаНПДПриИзменении(ЭтотОбъект, Элемент);

КонецПроцедуры

&НаКлиенте
Процедура НомерЧекаНПДНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	ОплатаПлатежнойКартойКлиент.НомерЧекаНПДНачалоВыбора(ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура НомерЧекаНПДАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)

	ОплатаПлатежнойКартойКлиент.НомерЧекаНПДАвтоПодбор(ЭтотОбъект, Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ДекорацияЧекНаВозвратНажатие(Элемент)

	ОплатаПлатежнойКартойКлиент.ДекорацияЧекНажатие(ЭтотОбъект, Элемент);

КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаСтавкаНДСПриИзменении(Элемент)

	ОплатаПлатежнойКартойКлиентСервер.ЗаполнитьРеквизитыРасшифровкаПлатежа(ЭтотОбъект);
	Если ЗначениеЗаполнено(Объект.РасшифровкаПлатежа) Тогда
		ОплатаПлатежнойКартойКлиент.СтавкаНДСПриИзменении(ЭтотОбъект, Объект.РасшифровкаПлатежа[0]);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КурсВзаиморасчетовПриИзменении(Элемент)

	ОплатаПлатежнойКартойКлиент.КурсВзаиморасчетовПриИзменении(ЭтотОбъект, Элемент);

КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаОтражениеАвансаПредставлениеПриИзменении(Элемент)
	
	ОплатаПлатежнойКартойКлиент.ОтражениеАвансаПредставлениеПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаОтражениеАвансаПредставлениеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ОплатаПлатежнойКартойКлиент.ОтражениеАвансаПредставлениеОбработкаВыбора(ЭтотОбъект, Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СпособПогашенияЗадолженностиПриИзменении(Элемент)

	ОплатаПлатежнойКартойКлиент.СпособПогашенияЗадолженностиПриИзменении(ЭтотОбъект, Элемент);

КонецПроцедуры

&НаКлиенте
Процедура СделкаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	ОплатаПлатежнойКартойКлиент.СделкаНачалоВыбора(ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ДеятельностьНаПатентеПриИзменении(Элемент)
	
	ОплатаПлатежнойКартойКлиент.ДеятельностьНаПатентеПриИзменении(ЭтотОбъект);
	ДеятельностьНаПатентеПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПатентПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.Патент) Тогда
		Объект.ДеятельностьНаПатенте = Истина;
		ОплатаПлатежнойКартойКлиент.ДеятельностьНаПатентеПриИзменении(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РозничнаяВыручкаРасходыУСНПриИзменении(Элемент)
	
	Если Объект.Графа7_УСН = 0 Тогда
		Объект.НДС_УСН = 0;
	КонецЕсли;
	
	ОплатаПлатежнойКартойКлиентСервер.УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеятельностьНаТорговомСбореПриИзменении(Элемент)
	
	Если Объект.ДеятельностьНаТорговомСборе И Объект.ДеятельностьНаПатенте Тогда
		Объект.ДеятельностьНаПатенте = Ложь;
		Объект.Патент                = Неопределено;
	КонецЕсли;
	
	ЗаполнитьОтражениеВУСННаСервере();
	
	ОплатаПлатежнойКартойКлиентСервер.УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

#Область РеквизитыНПД

&НаКлиенте
Процедура ДекорацияЧекНПДНажатие(Элемент)
	
	ОплатаПлатежнойКартойКлиент.ДекорацияЧекНажатие(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура УслугаНПДПриИзменении(Элемент)

	ОплатаПлатежнойКартойКлиент.УслугаНПДПриИзменении(ЭтотОбъект, Элемент);

КонецПроцедуры

&НаКлиенте
Процедура УслугаНПДОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	РаботаСНоменклатуройКлиент.НоменклатураОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура УслугаНПДАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ПараметрыПолученияДанных.Вставить("ВидыНоменклатуры", "Услуги");
	
	РаботаСНоменклатуройКлиент.НоменклатураАвтоПодбор(
		Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура УслугаНПДОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ПараметрыПолученияДанных.Вставить("ВидыНоменклатуры", "Услуги");
	
	РаботаСНоменклатуройКлиент.НоменклатураОкончаниеВводаТекста(
		Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстНеобходимоЗаполнитьПатентОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	ОплатаПлатежнойКартойКлиент.ТекстНеобходимоЗаполнитьПатентОбработкаНавигационнойСсылки(
		ЭтотОбъект,
		Элемент,
		НавигационнаяСсылкаФорматированнойСтроки,
		СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область РеквизитыШапки

&НаСервере
Процедура ВидОперацииПриИзмененииНаСервере()
	
	ОплатаПлатежнойКартойФормы.ВидОперацииПриИзменении(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ДатаПриИзмененииСервер()
	
	ОплатаПлатежнойКартойФормы.ДатаПриИзменении(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииСервер()
	
	ОплатаПлатежнойКартойФормы.ОрганизацияПриИзменении(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура КонтрагентПриИзмененииСервер()
	
	ОплатаПлатежнойКартойФормы.КонтрагентПриИзмененииСервер(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ВидОплатыПриИзмененииНаСервере()
	
	СтруктураРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.ВидОплаты, "Контрагент, ДоговорКонтрагента, СчетУчетаРасчетов");
	
	Объект.СчетКасса         = СтруктураРеквизитов.СчетУчетаРасчетов;
	Объект.Эквайер           = СтруктураРеквизитов.Контрагент;
	Объект.ДоговорЭквайринга = СтруктураРеквизитов.ДоговорКонтрагента;
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаПлатежаДоговорКонтрагентаПриИзменении(Элемент)
	
	СтрокаПлатеж = Объект.РасшифровкаПлатежа[0];
	ОплатаПлатежнойКартойКлиентСервер.ИнициализироватьСвойстваПлатежа(ЭтотОбъект);
	
	Если РасшифровкаПлатежаДоговорКонтрагента = СвойстваПлатежа.ДоговорКонтрагента Тогда
		Возврат;
	КонецЕсли;
	
	РасшифровкаПлатежаДоговорКонтрагентаПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьСвязанныеРеквизиты()
	
	Объект.СчетКасса         = ПредопределенноеЗначение("ПланСчетов.Хозрасчетный.ПустаяСсылка");
	Объект.Эквайер           = ПредопределенноеЗначение("Справочник.Контрагенты.ПустаяСсылка");
	Объект.ДоговорЭквайринга = ПредопределенноеЗначение("Справочник.ДоговорыКонтрагентов.ПустаяСсылка");
	
КонецПроцедуры

&НаСервере
Процедура СуммаДокументаПриИзмененииНаСервере()

	Если ПрименениеУСН И УчетВПродажныхЦенах Тогда
		ОплатаПлатежнойКартойФормы.ЗаполнитьОтражениеВУСН(ЭтотОбъект);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОтражениеВУСННаСервере()
	
	ОплатаПлатежнойКартойФормы.ЗаполнитьОтражениеВУСН(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область Патент

&НаСервере
Процедура ДеятельностьНаПатентеПриИзмененииНаСервере()
	
	ОплатаПлатежнойКартойФормы.ДеятельностьНаПатентеПриИзменении(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПатентОбработкаВыбора(ВыбранныйПатент)
	
	Если ТипЗнч(ВыбранныйПатент) <> Тип("СправочникСсылка.Патенты") Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьПатентОбработкаВыбораНаСервере(ВыбранныйПатент);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПатентОбработкаВыбораНаСервере(ВыбранныйПатент)
	
	ОплатаПлатежнойКартойФормы.ЗаполнитьПатентОбработкаВыбора(ЭтотОбъект, ВыбранныйПатент);
	
КонецПроцедуры

#КонецОбласти

#Область РеквизитыРасшифровкиПлатежа

&НаСервере
Функция ПоместитьРасшифровкаПлатежаВоВременноеХранилищеНаСервере()
	
	Возврат ПоместитьВоВременноеХранилище(Объект.РасшифровкаПлатежа.Выгрузить(), УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Процедура РасшифровкаПлатежаДоговорКонтрагентаПриИзмененииНаСервере()
	
	ОплатаПлатежнойКартойКлиентСервер.ЗаполнитьРеквизитыРасшифровкаПлатежа(ЭтотОбъект);
	СтрокаПлатеж = Объект.РасшифровкаПлатежа[0];
	ОплатаПлатежнойКартойФормы.ДоговорКонтрагентаПриИзменении(ЭтотОбъект, СтрокаПлатеж);
	ОплатаПлатежнойКартойКлиентСервер.ЗаполнитьРеквизитыРасшифровкаПлатежа(ЭтотОбъект, Истина, СтрокаПлатеж);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаРасшифровкиПлатежа(РезультатВыбора)
	
	Если ТипЗнч(РезультатВыбора) = Тип("Структура") Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, РезультатВыбора);
		ЗаполнитьЗначенияСвойств(Объект,     РезультатВыбора, "СуммаДокумента, Графа5_УСН");
		
		ПолучитьРасшифровкаПлатежаИзВременногоХранилища(РезультатВыбора.АдресХранилищаРасшифровкаПлатежа);
		
		Модифицированность = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьРасшифровкаПлатежаИзВременногоХранилища(АдресХранилищаРасшифровкаПлатежа)
	
	РасшифровкаПлатежа = ОплатаПлатежнойКартойВызовСервера.ДанныеРасшифровкиПлатежа(АдресХранилищаРасшифровкаПлатежа);
	
	Объект.РасшифровкаПлатежа.Очистить();
	Если РасшифровкаПлатежа = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ТекущаяСтрока Из РасшифровкаПлатежа Цикл
		ЗаполнитьЗначенияСвойств(Объект.РасшифровкаПлатежа.Добавить(), ТекущаяСтрока);
	КонецЦикла;
	
	ОплатаПлатежнойКартойКлиентСервер.ЗаполнитьРеквизитыРасшифровкаПлатежа(
		ЭтотОбъект,
		Истина,
		РасшифровкаПлатежа[0],
		РасшифровкаПлатежа);
		
	ОплатаПлатежнойКартойКлиентСервер.УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ЧекиНПД

&НаКлиенте
Процедура ОжидатьАннулированиеЧекаВФонеЗавершение(ДлительнаяОперация, ДополнительныеПараметры) Экспорт
	
	Если ДлительнаяОперация = Неопределено Тогда
		ОплатаПлатежнойКартойВызовСервера.ПоказатьОшибкуАннулированияЧека("Ошибка соединения");
		Возврат;
	КонецЕсли;
	
	ЧекАннулирован = Ложь;
	
	Если ЗначениеЗаполнено(ДлительнаяОперация)
		И ДлительнаяОперация.Статус = "Выполнено" Тогда
		
		ЧекАннулирован = ОбработатьРезультатАннулированияЧекаВФоне(ДлительнаяОперация.АдресРезультата);
		ОплатаПлатежнойКартойКлиент.ЗапуститьОжиданиеРезультатаАннулированияЧека(ЭтотОбъект);
		
	ИначеЕсли ДлительнаяОперация.Статус = "Ошибка" Тогда
		
		ОплатаПлатежнойКартойВызовСервера.ПоказатьОшибкуАннулированияЧека(ДлительнаяОперация.КраткоеПредставлениеОшибки);
		
	КонецЕсли;
	
	Если ЧекАннулирован Тогда
		ОповеститьОбИзменении(Тип("ДокументСсылка.ОплатаПлатежнойКартой"));
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ОбработатьРезультатАннулированияЧекаВФоне(АдресРезультата)
	
	Возврат ОплатаПлатежнойКартойФормы.ОбработатьРезультатАннулированияЧекаВФоне(ЭтотОбъект, АдресРезультата);
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ЗапуститьОжиданиеРезультатаАннулированияЧека() Экспорт
	
	ДлительнаяОперация = ЧекиНПДВызовСервера.ЗапуститьПроверкуРезультатаАннулированияЧекаВФоне(Объект.Ссылка,
		 ПараметрыОжиданияРезультата, УникальныйИдентификатор);
	ЧекиНПДКлиент.ОжидатьАннулированиеЧекаВФоне(ДлительнаяОперация, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьСтатусОфлайнЧековНПД()
	
	ЧекиНПДКлиент.ОбновитьСтатусыОфлайнЧековНПД();
	
КонецПроцедуры

#КонецОбласти

// Процедура показывает новости, требующие прочтения (важные и очень важные)
//
&НаКлиенте
Процедура Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии()
	
	// ИнтернетПоддержкаПользователей.Новости.Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии
	ИдентификаторыСобытийПриОткрытии = "ПриОткрытии";
	// Конец ИнтернетПоддержкаПользователей.Новости.Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии
	
	ОбработкаНовостейКлиент.КонтекстныеНовости_ПоказатьНовостиТребующиеПрочтенияПриОткрытии(ЭтотОбъект, ИдентификаторыСобытийПриОткрытии);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункцииБСП

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти