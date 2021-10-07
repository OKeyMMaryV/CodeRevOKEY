﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
 	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
    
	// Стандартные действия при создании на сервере.
	бит_РаботаСДиалогамиСервер.СписокПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтаФорма);
	
	бит_РаботаСДиалогамиСервер.УстановитьОтборПоОсновнойОрганизации(ЭтаФорма, "Список", "Организация");
	
	// Заполним значения реквизитов формы.
	МетаРегБухБюджетирование = Метаданные.РегистрыБухгалтерии.бит_Бюджетирование;
	МетаРегБухМеждународный  = Метаданные.РегистрыБухгалтерии.бит_Дополнительный_2;
	
	фРегБухБюджетирование = бит_ПраваДоступа.ПолучитьОбъектДоступаПоМетаданным(МетаРегБухБюджетирование);
	фРегБухМеждународный  = бит_ПраваДоступа.ПолучитьОбъектДоступаПоМетаданным(МетаРегБухМеждународный);
    
	Если Параметры.Свойство("ОбъектСистемы") Тогда
		//***БИТ***Теплова***
        //фФормаСпискаОткрытаСОтбором = Истина;
		//***БИТ***Теплова***
    	фИмяРегистраОтбор = Параметры.ОбъектСистемы.ИмяОбъекта;
        Если фИмяРегистраОтбор = "бит_Бюджетирование" Тогда
			Заголовок = Заголовок + " (бюджетирование)";			
		//БИТ Тртилек 19.01.2012
		//ИначеЕсли фИмяРегистраОтбор = "бит_Дополнительный_2" Тогда 
		//	Заголовок = Заголовок + " (МСФО)";	
		///БИТ Тртилек
		КонецЕсли;         
	КонецЕсли;
	
	фФормаСпискаОткрытаСОтбором = Ложь; //***БИТ***Теплова**
	
	Если фИмяРегистраОтбор = "бит_Бюджетирование" Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "ЦФО",,,, Ложь, РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ);
		Элементы.Список.ПодчиненныеЭлементы.ЦФО.Видимость = Истина;
	КонецЕсли;
    	
    // При необходимости установка отбора по объекту системы.
    УстановитьОтборВСписке();
        
	// Установить видимость реквизитов и заголовков колонок.	
	УправлениеЭлементамиФормы();
		
КонецПроцедуры // ПриСозданииНаСервере()

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если фОтказ Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры // ПриОткрытии()

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеОсновнойОрганизации" Тогда
		бит_РаботаСДиалогамиКлиент.ИзменитьОтборПоОсновнойОрганизации(Список, ,Параметр);		
	КонецЕсли;
	
КонецПроцедуры // ОбработкаОповещения()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	
	бит_РаботаСДиалогамиСервер.ВосстановитьОтборСписка(Список, Настройки, "Организация");

КонецПроцедуры // СписокПередЗагрузкойПользовательскихНастроекНаСервере()

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

#Область СтандартныеПодсистемыОбработчикиКоманд

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура осуществляет управление доступностью/видимостью элементов формы.
// 
// Параметры:
//  Нет.
// 
&НаСервере 
Процедура УправлениеЭлементамиФормы()
	
	ТолькоБюджетирование = фИмяРегистраОтбор = "бит_Бюджетирование";
	ТолькоМУ 			 = бит_ОбщегоНазначения.ЕстьОбъектыМСФО() И фИмяРегистраОтбор = "бит_Дополнительный_2";
	
	Элементы.ОбъектСистемы.Видимость 		   = Не(ТолькоБюджетирование Или ТолькоМУ);
    
    Элементы.Организация.Видимость             = Не ТолькоБюджетирование;
    
    Элементы.Сценарий.Видимость	               = ТолькоБюджетирование;
	Элементы.ПереоценкаСуммаСценарий.Видимость = ТолькоБюджетирование;
    
	Если бит_ОбщегоНазначения.ЕстьОбъектыМСФО() И бит_ОбщегоНазначения.ЕстьРеквизит("ПереоценкаСуммаМУ", Метаданные.Документы.бит_ПереоценкаВалютныхДенежныхСтатей) Тогда
		Элементы.ПереоценкаСуммаМУ.Видимость = Не ТолькоБюджетирование;
	КонецЕсли;
	
КонецПроцедуры // УправлениеЭлементамиФормы()

// Процедура устанавливает отбор в списке по объекту системы при необходимости.
// 
// Параметры:
//  Нет.
// 
&НаСервере 
Процедура УстановитьОтборВСписке()
	
    Если ПустаяСтрока(фИмяРегистраОтбор) Тогда
        МетаРегБухДляОтбора    = Метаданные.РегистрыБухгалтерии["бит_Бюджетирование"];
    	ОбъектСистемыДляОтбора = бит_ПраваДоступа.ПолучитьОбъектДоступаПоМетаданным(МетаРегБухДляОтбора);    	
    	бит_ОбщегоНазначенияКлиентСервер.УстановитьОтборУСписка(Список.Отбор
														   , Новый ПолеКомпоновкиДанных("ОбъектСистемы")
														   , ОбъектСистемыДляОтбора
                                                           , ВидСравненияКомпоновкиДанных.НеРавно);
    Иначе
        МетаРегБухДляОтбора    = Метаданные.РегистрыБухгалтерии[фИмяРегистраОтбор];
    	ОбъектСистемыДляОтбора = бит_ПраваДоступа.ПолучитьОбъектДоступаПоМетаданным(МетаРегБухДляОтбора);    	
    	бит_ОбщегоНазначенияКлиентСервер.УстановитьОтборУСписка(Список.Отбор
														   , Новый ПолеКомпоновкиДанных("ОбъектСистемы")
														   , ОбъектСистемыДляОтбора);
    КонецЕсли;
	
КонецПроцедуры // УстановитьОтборВСписке()

#КонецОбласти 