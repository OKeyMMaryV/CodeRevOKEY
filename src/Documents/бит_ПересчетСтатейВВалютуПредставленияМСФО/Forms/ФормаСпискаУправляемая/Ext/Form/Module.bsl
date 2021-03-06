////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеОсновнойОрганизации" Тогда
		бит_РаботаСДиалогамиКлиент.ИзменитьОтборПоОсновнойОрганизации(Список, ,Параметр);		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// бит_DKravchenko Процедура - обработчик события "ПриОткрытии" формы.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если фОтказ Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЕРВЕРНЫЕ ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// бит_DKravchenko Процедура - обработчик события "ПриСозданииНаСервере" формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// стандартные действия при создании на сервере
	бит_РаботаСДиалогамиСервер.СписокПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтаФорма);
	
	бит_РаботаСДиалогамиСервер.УстановитьОтборПоОсновнойОрганизации(ЭтаФорма, "Список", "Организация");
	
	МетаданныеОбъекта = Метаданные.Документы.бит_ПереоценкаВалютныхДенежныхСтатей;
	
	// Вызов механизма защиты.
	бит_ЛицензированиеБФCервер.ПроверитьВозможностьРаботы(ЭтаФорма,МетаданныеОбъекта.ПолноеИмя(),фОтказ);
	
	Если фОтказ Тогда
		Возврат;
	КонецЕсли;
	
	// Заполним значения реквизитов формы.
	МетаРегБухБюджетирование = Метаданные.РегистрыБухгалтерии.бит_Бюджетирование;
	МетаРегБухМеждународный  = Метаданные.РегистрыБухгалтерии.бит_Дополнительный_2;
	
	фРегБухБюджетирование = бит_ПраваДоступа.ПолучитьОбъектДоступаПоМетаданным(МетаРегБухБюджетирование);
	фРегБухМеждународный  = бит_ПраваДоступа.ПолучитьОбъектДоступаПоМетаданным(МетаРегБухМеждународный);
	
	//Параметры.Свойство("ИмяРегистра", фИмяРегистраОтбор);
	//фФормаСпискаОткрытаСОтбором = ?(ЗначениеЗаполнено(фИмяРегистраОтбор), Истина, Ложь);
	Если Параметры.Свойство("РФ_РегистрБухгалтерии") Тогда
		фИмяРегистраОтбор = Параметры.РФ_РегистрБухгалтерии.ИмяОбъекта;
		фФормаСпискаОткрытаСОтбором = Истина; 	
	КонецЕсли;
	
	// При необходимости установим отбора по объекту системы.
	УстановитьОтборВСписке();
	
	// Установить видимость реквизитов и заголовков колонок.	
	УправлениеЭлементамиФормы();
	
	// Установим заголовок формы.
	Если фФормаСпискаОткрытаСОтбором Тогда
		
		Если фИмяРегистраОтбор = "бит_Бюджетирование" ТОгда
			Заголовок = Заголовок + " бюджетирования";
			
		//БИТ Тртилек 19.01.2012	
		//ИначеЕсли фИмяРегистраОтбор = "бит_Дополнительный_2" Тогда 
		//	Заголовок = Заголовок + " (МСФО)";
		///БИТ Тртилек
		
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	
	бит_РаботаСДиалогамиСервер.ВосстановитьОтборСписка(Список, Настройки, "Организация");

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЕРВЕРНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// бит_DKravchenko Процедура осуществляет управление доступностью/видимостью элементов формы.
//
// Параметры:
//  Нет.
//
&НаСервере 
Процедура УправлениеЭлементамиФормы()
	
	ТолькоБюджетирование = фИмяРегистраОтбор = "бит_Бюджетирование";
	ТолькоМУ 			 = бит_ОбщегоНазначения.ЕстьОбъектыМСФО() И фИмяРегистраОтбор = "бит_Дополнительный_2";
	
	Если фФормаСпискаОткрытаСОтбором Тогда
		Элементы.Сценарий.Видимость	   = ТолькоБюджетирование;
		Элементы.Организация.Видимость = Не ТолькоБюджетирование;
	Иначе
		Элементы.Сценарий.Видимость	   = Истина;
		Элементы.Организация.Видимость = Истина;
	КонецЕсли;
	
	Элементы.ОбъектСистемы.Видимость 		   = Не(ТолькоБюджетирование Или ТолькоМУ);
	Элементы.ПереоценкаСуммаСценарий.Видимость = Не ТолькоМУ;
	Если бит_ОбщегоНазначения.ЕстьОбъектыМСФО() И бит_ОбщегоНазначения.ЕстьРеквизит("ПереоценкаСуммаМУ", Метаданные.Документы.бит_ПересчетСтатейВВалютуПредставленияМСФО) Тогда
		Элементы.ПереоценкаСуммаМУ.Видимость = Не ТолькоБюджетирование;
	КонецЕсли;
	
КонецПроцедуры // УправлениеЭлементамиФормы()

// бит_DKravchenko Процедура устанавливает отбор в списке по объекту системы при необходимости.
//
// Параметры:
//  Нет.
// 
&НаСервере 
Процедура УстановитьОтборВСписке()
	
	Если Не фФормаСпискаОткрытаСОтбором Тогда
		Возврат;
	КонецЕсли;
	
	МетаРегБухДляОтбора    = Метаданные.РегистрыБухгалтерии[фИмяРегистраОтбор];
	ОбъектСистемыДляОтбора = бит_ПраваДоступа.ПолучитьОбъектДоступаПоМетаданным(МетаРегБухДляОтбора);
	
	бит_ОбщегоНазначенияКлиентСервер.УстановитьОтборУСписка(Список.Отбор
														   ,Новый ПолеКомпоновкиДанных("ОбъектСистемы")
														   ,ОбъектСистемыДляОтбора);
	
КонецПроцедуры // УстановитьОтборВСписке()

