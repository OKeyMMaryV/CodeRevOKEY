﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	
		
	// Вызов механизма защиты
	
	
	// Стандартные действия при создании на сервере.
	бит_РаботаСДиалогамиСервер.ФормаОбъектаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтаФорма, Объект);

	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ЭтоНовый = Параметры.Ключ.Пустая();
	
	Если ЭтоНовый
		И ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
		ИсточникЗаполнения = Параметры.ЗначениеКопирования;
	Иначе
		ИсточникЗаполнения = Объект.Ссылка;
	КонецЕсли;
	
	Дерево = бит_ДоговораСервер.ПолучитьДеревоПараметровФинДоговоров(ИсточникЗаполнения);
	
	ЗаполнитьДеревоСоставляющих(Дерево, ДеревоСоставляющих.ПолучитьЭлементы());
	
	// Заполняем кэш значений.
	ЗаполнитьКэшЗначений(мКэшЗначений);
	
	// Добавим ветку ОбщиеПараметры
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("СоставляющаяПлатежа", мКэшЗначений.ПустаяСоставляющая);
	НайденныеСтроки = Объект.СоставляющиеПлатежа.НайтиСтроки(СтруктураОтбора);
	
	Если НайденныеСтроки.Количество() = 0 Тогда
		ОбщиеПараметры = ДеревоСоставляющих.ПолучитьЭлементы().Вставить(0);
		ОбщиеПараметры.Группировка = "Общие параметры";
		
		Если ЭтоНовый Тогда
			НовыйОбщийПараметр = ОбщиеПараметры.ПолучитьЭлементы().Добавить();
			НовыйОбщийПараметр.Группировка = ПланыВидовХарактеристик.бит_ВидыПараметровФинансовыхДоговоров.СтатьяОборотовБДДСПоступление;
			НовыйОбщийПараметр.СоставляющаяПлатежа 	= мКэшЗначений.ПустаяСоставляющая;
			НовыйОбщийПараметр.Параметр 			= НовыйОбщийПараметр.Группировка;
		КонецЕсли;
	КонецЕсли;
	
	СоздатьДействияУровней();
	
	Элементы["ДеревоСоставляющихУровень_2"].Пометка = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Объект.СоставляющиеПлатежа.Очистить();
	
	ЭлементыДерева = ДеревоСоставляющих.ПолучитьЭлементы();
	
	Для Каждого ТекущаяСтрока Из ЭлементыДерева Цикл
		
		ПараметрыСтроки = ТекущаяСтрока.ПолучитьЭлементы();
		
		ЕстьПараметры = ПараметрыСтроки.Количество() > 0;
		
		Если НЕ ЕстьПараметры
			И ЗначениеЗаполнено(ТекущаяСтрока.СоставляющаяПлатежа) Тогда
			НоваяСтрока = Объект.СоставляющиеПлатежа.Добавить();
			
			НоваяСтрока.СоставляющаяПлатежа = ТекущаяСтрока.СоставляющаяПлатежа;
		КонецЕсли;
		
		Для Каждого СтрокаПараметра Из ПараметрыСтроки Цикл
			НоваяСтрока = Объект.СоставляющиеПлатежа.Добавить();
			
			НоваяСтрока.СоставляющаяПлатежа = ТекущаяСтрока.СоставляющаяПлатежа;
			НоваяСтрока.Параметр 			= СтрокаПараметра.Параметр;
			НоваяСтрока.ЗначениеПоУмолчанию = СтрокаПараметра.ЗначениеПоУмолчанию;
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоСоставляющих

&НаКлиенте
Процедура ДеревоСоставляющихПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоСоставляющихПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	ТекущиеДанные = Элементы.ДеревоСоставляющих.ТекущиеДанные;
	
	Модифицированность = Истина;
	
	Отказ = Истина;
	
	Если Копирование
		И НЕ ТекущиеДанные = Неопределено Тогда
		
		РодительСтроки = ТекущиеДанные.ПолучитьРодителя();
		
		Если РодительСтроки = Неопределено Тогда
			ЭлементыРодителя = ДеревоСоставляющих.ПолучитьЭлементы();
		Иначе	
			ЭлементыРодителя = РодительСтроки.ПолучитьЭлементы();
		КонецЕсли;
		
		НоваяСтрока = ЭлементыРодителя.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущиеДанные,,"ЗначениеПоУмолчанию");
		ПараметрыНовойСтроки = НоваяСтрока.ПолучитьЭлементы();
		
		
		ПараметрыТекущейСтроки = ТекущиеДанные.ПолучитьЭлементы();
		
		Для Каждого ТекущийПараметр Из ПараметрыТекущейСтроки Цикл
			НовыйПараметр = ПараметрыНовойСтроки.Добавить();
			ЗаполнитьЗначенияСвойств(НовыйПараметр, ТекущийПараметр,,"ЗначениеПоУмолчанию");
		КонецЦикла;
		
	Иначе
		
		Если ТекущиеДанные = Неопределено Тогда
			ЭлементыРодителя = ДеревоСоставляющих.ПолучитьЭлементы();
			НоваяСтрока = ЭлементыРодителя.Добавить();
			НоваяСтрока.Группировка = мКэшЗначений.ПустаяСоставляющая;
		Иначе
			РодительСтроки = ТекущиеДанные.ПолучитьРодителя();
			
			Если РодительСтроки = Неопределено Тогда
				ЭлементыРодителя = ТекущиеДанные.ПолучитьЭлементы();
			Иначе	
				ЭлементыРодителя = РодительСтроки.ПолучитьЭлементы();
			КонецЕсли;
			НоваяСтрока = ЭлементыРодителя.Добавить();
			НоваяСтрока.Группировка = мКэшЗначений.ПустойПараметр;
		КонецЕсли;
		
		ИДСтроки = НоваяСтрока.ПолучитьИдентификатор();
		
		Элементы.ДеревоСоставляющих.ТекущаяСтрока = ИДСтроки;
		Элементы.ДеревоСоставляющих.Развернуть(ИДСтроки, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоСоставляющихПередУдалением(Элемент, Отказ)
	
	ТекущиеДанные = Элементы.ДеревоСоставляющих.ТекущиеДанные;
	
	Если ТекущиеДанные.Группировка = "Общие параметры" Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоСоставляющихГруппировкаПриИзменении(Элемент)
	
	СинхронизироватьЗначениеГруппировкиИЗначимогоРеквизита();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоСоставляющихГруппировкаОчистка(Элемент, СтандартнаяОбработка)
	
	СинхронизироватьЗначениеГруппировкиИЗначимогоРеквизита();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоСоставляющихЗначениеПоУмолчаниюНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ДеревоСоставляющих.ТекущиеДанные;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("СтатьяОборотовБДДСПоступление"	, мКэшЗначений.СтатьяОборотовБДДСПоступление);
	СтруктураПараметров.Вставить("СтатьяОборотовБДДСРасходование"	, мКэшЗначений.СтатьяОборотовБДДСРасходование);
	СтруктураПараметров.Вставить("СтатьяОборотовБДРПоступление"		, мКэшЗначений.СтатьяОборотовБДРПоступление);
	СтруктураПараметров.Вставить("СтатьяОборотовБДРРасходование"	, мКэшЗначений.СтатьяОборотовБДРРасходование);
	СтруктураПараметров.Вставить("Перечисления"						, мКэшЗначений.Перечисления);
	
	бит_РаботаСДиалогамиКлиент.НачалоВыбораЗначенияПараметраСоставляющейПлатежа(ЭтаФорма, Элемент, ТекущиеДанные, СтруктураПараметров, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоСоставляющихЗначениеПоУмолчаниюОчистка(Элемент, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ДеревоСоставляющих.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	бит_РаботаСДиалогамиКлиент.ОчисткаЗначенияПараметраСоставляющейПлатежа(ТекущиеДанные, "Параметр", "ЗначениеПоУмолчанию", СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаДобавитьСоставляющую(Команда)
	
	Модифицированность = Истина;
	
	Оповещение = Новый ОписаниеОповещения("КомандаДобавитьСоставляющуюОкончание", ЭтотОбъект); 
	ОткрытьФорму("Справочник.бит_СоставляющиеПлатежейПоФинДоговорам.ФормаВыбора",, ЭтаФорма,,,,Оповещение, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

// Процедура окончание процедуры "КомандаДобавитьСоставляющую".
// 
&НаКлиенте 
Процедура КомандаДобавитьСоставляющуюОкончание(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если НЕ ЗначениеЗаполнено(РезультатВыбора) Тогда
		Возврат;
	КонецЕсли;
	
	ДобавитьСоставляющуюПлатежа(РезультатВыбора);
	
	ТекущиеДанные = Элементы.ДеревоСоставляющих.ТекущиеДанные;
	Элементы.ДеревоСоставляющих.Развернуть(ТекущиеДанные.ПолучитьИдентификатор(), Истина);
	
КонецПроцедуры // КомандаДобавитьСоставляющуюОкончание()

&НаКлиенте
Процедура КомандаЗаполнитьСоставляющиеКредитаЗайма(Команда)
	
	ЗаполнитьСоставляющиеПлатежаПоУмолчанию("Кредит");
	
	НайденнаяКоманда = Команды.Найти("ДеревоСоставляющихУровень_2");
	
	Если НЕ НайденнаяКоманда = Неопределено Тогда
		ДействиеДеревоСоставляющихУровень(НайденнаяКоманда);
		Элементы["ДеревоСоставляющихУровень_2"].Пометка = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаполнитьСоставляющиеКредитнойЛинии(Команда)
	
	ЗаполнитьСоставляющиеПлатежаПоУмолчанию("КредитнаяЛиния");
	
	НайденнаяКоманда = Команды.Найти("ДеревоСоставляющихУровень_2");
	
	Если НЕ НайденнаяКоманда = Неопределено Тогда
		ДействиеДеревоСоставляющихУровень(НайденнаяКоманда);
		Элементы["ДеревоСоставляющихУровень_2"].Пометка = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаполнитьСоставляющиеКредитаЗаймаАннутитетный(Команда)
	
	ЗаполнитьСоставляющиеПлатежаПоУмолчанию("Кредит", "А");
	
	НайденнаяКоманда = Команды.Найти("ДеревоСоставляющихУровень_2");
	
	Если НЕ НайденнаяКоманда = Неопределено Тогда
		ДействиеДеревоСоставляющихУровень(НайденнаяКоманда);
		Элементы["ДеревоСоставляющихУровень_2"].Пометка = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаполнитьСоставляющиеКредитнойЛинииАннуитетный(Команда)
	
	ЗаполнитьСоставляющиеПлатежаПоУмолчанию("КредитнаяЛиния", "А");
	
	НайденнаяКоманда = Команды.Найти("ДеревоСоставляющихУровень_2");
	
	Если НЕ НайденнаяКоманда = Неопределено Тогда
		ДействиеДеревоСоставляющихУровень(НайденнаяКоманда);
		Элементы["ДеревоСоставляющихУровень_2"].Пометка = Истина;
	КонецЕсли;
	
КонецПроцедуры

// Процедура - действие динамически создаваемых команд "ДеревоДокументовУровень_<й>". 
// Выполняется свертка/разворачивание дерева счетов. 
// 
&НаКлиенте
Процедура ДействиеДеревоСоставляющихУровень(Команда)
	
	КнопкиУровней = Элементы.ДеревоСоставляющихГруппаУровни.ПодчиненныеЭлементы;
	
	НомПодчерк = Найти(Команда.Имя, "_");
	Если НомПодчерк > 0 Тогда
	
		 НомУровняСтр = Сред(Команда.Имя, НомПодчерк + 1);
		 Попытка 			 
			 НомУровня = Число(НомУровняСтр);  		 
		 Исключение  			 
			 НомУровня = -1;    			 
		 КонецПопытки; 
		 
		 Если НомУровня > 0 Тогда
		 
		   бит_РаботаСДиалогамиКлиент.РазвернутьДоУровня(Элементы.ДеревоСоставляющих, ДеревоСоставляющих, НомУровня);
		   
		   Уровень = 1;
		   Для каждого Кнопка Из КнопкиУровней Цикл 		   
		   	   Кнопка.Пометка = Ложь;     			   
			   Если Уровень = НомУровня Тогда   			   
			   	  Кнопка.Пометка = Истина;  			   
			   КонецЕсли;    			   
			   Уровень = Уровень + 1;
		   КонецЦикла; 
		   
		 КонецЕсли; 
		 
		 фУровеньПросмотраДерева = НомУровня;
		 
	 КонецЕсли;
	
КонецПроцедуры // ДействиеДеревоДокументовУровень()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура заполняет кэш значений, необходимый при работе на клиенте.
// 
// Параметры:
//  КэшированныеЗначения - Структура.
// 
&НаСервере
Процедура ЗаполнитьКэшЗначений(КэшированныеЗначения)
	
	КэшированныеЗначения = Новый Структура;
	
	КэшПеречисления = Новый Структура;
	КэшПеречисления.Вставить("бит_РасходДоход"		 , бит_ОбщегоНазначения.КэшироватьЗначенияПеречисления(Перечисления.бит_РасходДоход));
	КэшПеречисления.Вставить("бит_ТипыСтатейОборотов", бит_ОбщегоНазначения.КэшироватьЗначенияПеречисления(Перечисления.бит_ТипыСтатейОборотов));
	КэшПеречисления.Вставить("бит_ТипыПлатежейПоФинансовымДоговорам"		 , бит_ОбщегоНазначения.КэшироватьЗначенияПеречисления(Перечисления.бит_ТипыПлатежейПоФинансовымДоговорам));
	КэшПеречисления.Вставить("бит_АлгоритмыРасчетовПоФинДоговорам"			 , бит_ОбщегоНазначения.КэшироватьЗначенияПеречисления(Перечисления.бит_АлгоритмыРасчетовПоФинДоговорам));
	КэшПеречисления.Вставить("бит_КонтекстыВыполненияПользовательскихФункций", бит_ОбщегоНазначения.КэшироватьЗначенияПеречисления(Перечисления.бит_КонтекстыВыполненияПользовательскихФункций));
	
	КэшированныеЗначения.Вставить("Перечисления", КэшПеречисления);

	
	КэшированныеЗначения.Вставить("ПустаяСоставляющая", Справочники.бит_СоставляющиеПлатежейПоФинДоговорам.ПустаяСсылка());
	КэшированныеЗначения.Вставить("ПустойПараметр"	  , ПланыВидовХарактеристик.бит_ВидыПараметровФинансовыхДоговоров.ПустаяСсылка());
	
	КэшированныеЗначения.Вставить("СтатьяОборотовБДДСПоступление"  , ПланыВидовХарактеристик.бит_ВидыПараметровФинансовыхДоговоров.СтатьяОборотовБДДСПоступление);
	КэшированныеЗначения.Вставить("СтатьяОборотовБДДСРасходование" , ПланыВидовХарактеристик.бит_ВидыПараметровФинансовыхДоговоров.СтатьяОборотовБДДСРасходование);
	КэшированныеЗначения.Вставить("СтатьяОборотовБДРПоступление"   , ПланыВидовХарактеристик.бит_ВидыПараметровФинансовыхДоговоров.СтатьяОборотовБДРПоступление);
	КэшированныеЗначения.Вставить("СтатьяОборотовБДРРасходование"  , ПланыВидовХарактеристик.бит_ВидыПараметровФинансовыхДоговоров.СтатьяОборотовБДРРасходование);
	
КонецПроцедуры // ЗаполнитьКэшЗначений()

// Процедура создает кнопки раскрытия/свертки уровней дерева составляющих.
// 
&НаСервере
Процедура СоздатьДействияУровней()

	// Очищаем существующие кнопки подменю
	КоличествоЭлементов = Элементы.ДеревоСоставляющихГруппаУровни.ПодчиненныеЭлементы.Количество();
	Для Счетчик = 1 По КоличествоЭлементов Цикл
	
		ИндексКнопки = КоличествоЭлементов - Счетчик;
		Кнопка = Элементы.ДеревоСоставляющихГруппаУровни.ПодчиненныеЭлементы[ИндексКнопки];
		Элементы.Удалить(Кнопка);
	
	КонецЦикла; 
	
	// Создадим команды и кнопки в подменю
	Для Уровень = 1 По 2 Цикл
		
		ИмяКоманды = "ДеревоСоставляющихУровень_" + Уровень;
		
		КомандаУровня = Команды.Найти(ИмяКоманды);
		
		Если КомандаУровня = Неопределено Тогда
			
			КомандаУровня = Команды.Добавить(ИмяКоманды);
			КомандаУровня.Действие = "ДействиеДеревоСоставляющихУровень";
			
		КонецЕсли; 
		
		НоваяКнопка = Элементы.Добавить(ИмяКоманды,Тип("КнопкаФормы"), Элементы.ДеревоСоставляющихГруппаУровни);
		
		НоваяКнопка.ИмяКоманды = ИмяКоманды;
		НоваяКнопка.Заголовок  = "Уровень " + Уровень;
			
	КонецЦикла;

КонецПроцедуры // СоздатьДействияУровней()

// Процедура синхронизирует значение группировки с тем реквизитом, данные которого она отображает.
// 
&НаСервере
Процедура СинхронизироватьЗначениеГруппировкиИЗначимогоРеквизита()
	
	ТекущаяСтрока = Элементы.ДеревоСоставляющих.ТекущаяСтрока;
	
	ТекущиеДанные = ДеревоСоставляющих.НайтиПоИдентификатору(ТекущаяСтрока);
	
	РодительСтроки = ТекущиеДанные.ПолучитьРодителя();
	
	Если РодительСтроки = Неопределено Тогда
		ТекущиеДанные.СоставляющаяПлатежа = ТекущиеДанные.Группировка;
	Иначе
		ТекущиеДанные.СоставляющаяПлатежа = РодительСтроки.Группировка;
		ТекущиеДанные.Параметр 			  = ТекущиеДанные.Группировка;
	КонецЕсли;
	
	Если НЕ ТекущиеДанные.Параметр.ТипЗначения = Неопределено Тогда	
		ТекущиеДанные.ЗначениеПоУмолчанию = ТекущиеДанные.Параметр.ТипЗначения.ПривестиЗначение();
	Иначе
		ТекущиеДанные.ЗначениеПоУмолчанию = Неопределено;
	КонецЕсли;
	
КонецПроцедуры	

// Процедура заполняет дерево составляющих. Вызывается рекурсивно.
// 
&НаСервереБезКонтекста
Процедура ЗаполнитьДеревоСоставляющих(ДеревоИсточник, ДеревоПриемник)
	
	Для Каждого ТекущаяСтрока Из ДеревоИсточник.Строки Цикл
		НоваяСтрока = ДеревоПриемник.Добавить();
		
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущаяСтрока);
		
		НоваяСтрока.ЗначениеПоУмолчанию = ТекущаяСтрока.Значение;
		
		ЗаполнитьДеревоСоставляющих(ТекущаяСтрока, НоваяСтрока.ПолучитьЭлементы());
	КонецЦикла;
	
КонецПроцедуры

// Процедура добавляет составляющую платежа в дерево составляющих.
// 
&НаСервере
Процедура ДобавитьСоставляющуюПлатежа(СоставляющаяПлатежа, ВидРасчета="Д")
	
	ЭлементыРодителя = ДеревоСоставляющих.ПолучитьЭлементы();
	
	НоваяСтрока = ЭлементыРодителя.Добавить();
	НоваяСтрока.Группировка			= СоставляющаяПлатежа;
	НоваяСтрока.СоставляющаяПлатежа = СоставляющаяПлатежа;
	
	ИДСтроки = НоваяСтрока.ПолучитьИдентификатор();
	
	Элементы.ДеревоСоставляющих.ТекущаяСтрока = ИДСтроки;
	
	// Заполним параметры по умолчанию
	ПараметрыСоставляющей = НоваяСтрока.ПолучитьЭлементы();
	
	// Алгоритм расчета
	НовыйПараметр = ПараметрыСоставляющей.Добавить();
	НовыйПараметр.Группировка 		  = ПланыВидовХарактеристик.бит_ВидыПараметровФинансовыхДоговоров.АлгоритмРасчета;
	НовыйПараметр.СоставляющаяПлатежа = СоставляющаяПлатежа;
	НовыйПараметр.Параметр 			  = НовыйПараметр.Группировка;
	НовыйПараметр.ТипПлатежа		  = СоставляющаяПлатежа.ТипПлатежаПоФинДоговору;
	
	Если СоставляющаяПлатежа.ТипПлатежаПоФинДоговору = Перечисления.бит_ТипыПлатежейПоФинансовымДоговорам.ОсновнойДолг
		И ВидРасчета = "Д" Тогда
		НовыйПараметр.ЗначениеПоУмолчанию = Перечисления.бит_АлгоритмыРасчетовПоФинДоговорам.РасчетСуммыОсновногоДолгаДифференцированный;
		
	ИначеЕсли СоставляющаяПлатежа.ТипПлатежаПоФинДоговору = Перечисления.бит_ТипыПлатежейПоФинансовымДоговорам.ОсновнойДолг
		И ВидРасчета = "А" Тогда
		НовыйПараметр.ЗначениеПоУмолчанию = Перечисления.бит_АлгоритмыРасчетовПоФинДоговорам.РасчетСуммыОсновногоДолгаАннуитетный;
		
	ИначеЕсли СоставляющаяПлатежа.ТипПлатежаПоФинДоговору = Перечисления.бит_ТипыПлатежейПоФинансовымДоговорам.Проценты Тогда
		НовыйПараметр.ЗначениеПоУмолчанию = Перечисления.бит_АлгоритмыРасчетовПоФинДоговорам.РасчетСуммыПроцентов;
		
	ИначеЕсли СоставляющаяПлатежа = Справочники.бит_СоставляющиеПлатежейПоФинДоговорам.КомиссияЗаВыдачу Тогда
		НовыйПараметр.ЗначениеПоУмолчанию = Перечисления.бит_АлгоритмыРасчетовПоФинДоговорам.РасчетКомиссииЗаВыдачу;
		
	ИначеЕсли СоставляющаяПлатежа.ТипПлатежаПоФинДоговору = Перечисления.бит_ТипыПлатежейПоФинансовымДоговорам.КомиссияЗаНеиспользованныйЛимит Тогда
		НовыйПараметр.ЗначениеПоУмолчанию = Перечисления.бит_АлгоритмыРасчетовПоФинДоговорам.РасчетКомиссииЗаНеиспользованныйЛимитВозобновляемая;	
	КонецЕсли;
	
	// Периодичность
	НовыйПараметр = ПараметрыСоставляющей.Добавить();
	НовыйПараметр.Группировка 		  = ПланыВидовХарактеристик.бит_ВидыПараметровФинансовыхДоговоров.Периодичность;
	НовыйПараметр.СоставляющаяПлатежа = СоставляющаяПлатежа;
	НовыйПараметр.Параметр			  = НовыйПараметр.Группировка;
	НовыйПараметр.ТипПлатежа		  = СоставляющаяПлатежа.ТипПлатежаПоФинДоговору;
	
	Если СоставляющаяПлатежа = Справочники.бит_СоставляющиеПлатежейПоФинДоговорам.КомиссияЗаВыдачу Тогда
		НовыйПараметр.ЗначениеПоУмолчанию = Перечисления.бит_ПериодичностьВыплатПоФинансовымДоговорам.Единовременно;
	Иначе
		НовыйПараметр.ЗначениеПоУмолчанию = Перечисления.бит_ПериодичностьВыплатПоФинансовымДоговорам.Ежемесячно;
	КонецЕсли;
	
	// Тип процентной ставки
	Если СоставляющаяПлатежа.ТипПлатежаПоФинДоговору = Перечисления.бит_ТипыПлатежейПоФинансовымДоговорам.Проценты Тогда
		
		НовыйПараметр = ПараметрыСоставляющей.Добавить();
		НовыйПараметр.Группировка		  = ПланыВидовХарактеристик.бит_ВидыПараметровФинансовыхДоговоров.ТипПроцентнойСтавки;
		НовыйПараметр.СоставляющаяПлатежа = СоставляющаяПлатежа;
		НовыйПараметр.Параметр			  = НовыйПараметр.Группировка;
		НовыйПараметр.ЗначениеПоУмолчанию = Перечисления.бит_ТипыПроцентныхСтавокПоФинансовымДоговорам.Фиксированная;
		НовыйПараметр.ТипПлатежа		  = СоставляющаяПлатежа.ТипПлатежаПоФинДоговору;
		
	КонецЕсли;
	
	// Процентная ставка
	Если НЕ СоставляющаяПлатежа.ТипПлатежаПоФинДоговору = Перечисления.бит_ТипыПлатежейПоФинансовымДоговорам.ОсновнойДолг Тогда
		
		НовыйПараметр = ПараметрыСоставляющей.Добавить();
		НовыйПараметр.Группировка		  = ПланыВидовХарактеристик.бит_ВидыПараметровФинансовыхДоговоров.ПроцентнаяСтавка;
		НовыйПараметр.СоставляющаяПлатежа = СоставляющаяПлатежа;
		НовыйПараметр.Параметр			  = НовыйПараметр.Группировка;
		НовыйПараметр.ЗначениеПоУмолчанию = 0;
		НовыйПараметр.ТипПлатежа		  = СоставляющаяПлатежа.ТипПлатежаПоФинДоговору;
		
	КонецЕсли;
	
	// Статья оборотов БДДС расходование
	НовыйПараметр = ПараметрыСоставляющей.Добавить();
	НовыйПараметр.Группировка		  = ПланыВидовХарактеристик.бит_ВидыПараметровФинансовыхДоговоров.СтатьяОборотовБДДСРасходование;
	НовыйПараметр.СоставляющаяПлатежа = СоставляющаяПлатежа;
	НовыйПараметр.Параметр			  = НовыйПараметр.Группировка;
	НовыйПараметр.ТипПлатежа		  = СоставляющаяПлатежа.ТипПлатежаПоФинДоговору;
	
	// Изменение кода. Начало. 15.05.2014{{
	Если СоставляющаяПлатежа = Справочники.бит_СоставляющиеПлатежейПоФинДоговорам.Проценты 
		ИЛИ СоставляющаяПлатежа = Справочники.бит_СоставляющиеПлатежейПоФинДоговорам.КомиссияЗаВыдачу 
		ИЛИ СоставляющаяПлатежа = Справочники.бит_СоставляющиеПлатежейПоФинДоговорам.КомиссияЗаНеиспользованныйЛимит  Тогда
		
		// Статья оборотов БДР расходование
		НовыйПараметр = ПараметрыСоставляющей.Добавить();
		НовыйПараметр.Группировка		  = ПланыВидовХарактеристик.бит_ВидыПараметровФинансовыхДоговоров.СтатьяОборотовБДРРасходование;
		НовыйПараметр.СоставляющаяПлатежа = СоставляющаяПлатежа;
		НовыйПараметр.Параметр			  = НовыйПараметр.Группировка;
		НовыйПараметр.ТипПлатежа		  = СоставляющаяПлатежа.ТипПлатежаПоФинДоговору;
		
	КонецЕсли;
	// Изменение кода. Конец. 15.05.2014}}
	
	// Дата первого платежа
	НовыйПараметр = ПараметрыСоставляющей.Добавить();
	НовыйПараметр.Группировка		  = ПланыВидовХарактеристик.бит_ВидыПараметровФинансовыхДоговоров.ДатаПервогоПлатежа;
	НовыйПараметр.СоставляющаяПлатежа = СоставляющаяПлатежа;
	НовыйПараметр.Параметр			  = НовыйПараметр.Группировка;
	НовыйПараметр.ЗначениеПоУмолчанию = Дата(1,1,1);
	НовыйПараметр.ТипПлатежа		  = СоставляющаяПлатежа.ТипПлатежаПоФинДоговору;
	
	// +СБ Кузнецова С. 2016-05-23 Задача Redmine № 2389
	Если СоставляющаяПлатежа.ТипПлатежаПоФинДоговору = Перечисления.бит_ТипыПлатежейПоФинансовымДоговорам.ОсновнойДолг Тогда
		
		НовыйПараметр = ПараметрыСоставляющей.Добавить();
		НовыйПараметр.Группировка		  = ПланыВидовХарактеристик.бит_ВидыПараметровФинансовыхДоговоров.СБ_ДатаПолученияКредита;
		НовыйПараметр.СоставляющаяПлатежа = СоставляющаяПлатежа;
		НовыйПараметр.Параметр			  = НовыйПараметр.Группировка;
		НовыйПараметр.ЗначениеПоУмолчанию = Дата(1,1,1);
		НовыйПараметр.ТипПлатежа		  = СоставляющаяПлатежа.ТипПлатежаПоФинДоговору;
		
		НовыйПараметр = ПараметрыСоставляющей.Добавить();
		НовыйПараметр.Группировка		  = ПланыВидовХарактеристик.бит_ВидыПараметровФинансовыхДоговоров.СБ_СуммаПоследнейВыплаты;
		НовыйПараметр.СоставляющаяПлатежа = СоставляющаяПлатежа;
		НовыйПараметр.Параметр			  = НовыйПараметр.Группировка;
		НовыйПараметр.ЗначениеПоУмолчанию = 0;
		НовыйПараметр.ТипПлатежа		  = СоставляющаяПлатежа.ТипПлатежаПоФинДоговору;
		
	КонецЕсли;
	// -СБ Кузнецова С.
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСоставляющиеПлатежаПоУмолчанию(РежимЗаполнения, ВидРасчета="Д")
	
	Если РежимЗаполнения = "Кредит" Тогда
		
		ЭлементыСоставляющие = ДеревоСоставляющих.ПолучитьЭлементы();
		
		ЭлементыСоставляющие.Очистить();
		
		ОбщиеПараметры = ЭлементыСоставляющие.Добавить();
		ОбщиеПараметры.Группировка = "Общие параметры";
		
		НовыйОбщийПараметр = ОбщиеПараметры.ПолучитьЭлементы().Добавить();
		НовыйОбщийПараметр.Группировка = ПланыВидовХарактеристик.бит_ВидыПараметровФинансовыхДоговоров.СтатьяОборотовБДДСПоступление;
		НовыйОбщийПараметр.СоставляющаяПлатежа 	= мКэшЗначений.ПустаяСоставляющая;
		НовыйОбщийПараметр.Параметр 			= НовыйОбщийПараметр.Группировка;
		
		ДобавитьСоставляющуюПлатежа(Справочники.бит_СоставляющиеПлатежейПоФинДоговорам.ПогашениеОсновногоДолга, ВидРасчета);
		ДобавитьСоставляющуюПлатежа(Справочники.бит_СоставляющиеПлатежейПоФинДоговорам.Проценты, ВидРасчета);
		ДобавитьСоставляющуюПлатежа(Справочники.бит_СоставляющиеПлатежейПоФинДоговорам.КомиссияЗаВыдачу, ВидРасчета);
		
	ИначеЕсли РежимЗаполнения = "КредитнаяЛиния" Тогда
		
		ЭлементыСоставляющие = ДеревоСоставляющих.ПолучитьЭлементы();
		
		ЭлементыСоставляющие.Очистить();
		
		ОбщиеПараметры = ЭлементыСоставляющие.Добавить();
		ОбщиеПараметры.Группировка = "Общие параметры";
		
		НовыйОбщийПараметр = ОбщиеПараметры.ПолучитьЭлементы().Добавить();
		НовыйОбщийПараметр.Группировка = ПланыВидовХарактеристик.бит_ВидыПараметровФинансовыхДоговоров.СтатьяОборотовБДДСПоступление;
		НовыйОбщийПараметр.СоставляющаяПлатежа 	= мКэшЗначений.ПустаяСоставляющая;
		НовыйОбщийПараметр.Параметр 			= НовыйОбщийПараметр.Группировка;
		
		ДобавитьСоставляющуюПлатежа(Справочники.бит_СоставляющиеПлатежейПоФинДоговорам.ПогашениеОсновногоДолга, ВидРасчета);
		ДобавитьСоставляющуюПлатежа(Справочники.бит_СоставляющиеПлатежейПоФинДоговорам.Проценты, ВидРасчета);
		ДобавитьСоставляющуюПлатежа(Справочники.бит_СоставляющиеПлатежейПоФинДоговорам.КомиссияЗаВыдачу, ВидРасчета);
		ДобавитьСоставляющуюПлатежа(Справочники.бит_СоставляющиеПлатежейПоФинДоговорам.КомиссияЗаНеиспользованныйЛимит, ВидРасчета);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти 
