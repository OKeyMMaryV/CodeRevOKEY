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
	
	МетаданныеОбъекта = Метаданные.Документы.бит_ЗаявкаНаРасходованиеСредств;
	
	// Добавление кнопки "Раскрасить по статусам".
	// Также добавляются процедуры: К-Подключаемый_РаскраситьПоСтатусам(), С-ОформитьСписокДокументовПоСтатусам().
	бит_РаботаСДиалогамиСервер.ДобавитьКнопкуРаскраситьПоСтатусам(Элементы, Команды, Элементы.ГруппаКоманднаяПанель,
																  МетаданныеОбъекта);
																  
	бит_РаботаСДиалогамиСервер.УстановитьОтборПоОсновнойОрганизации(ЭтаФорма, "Список", "Организация");
	
	ОформитьСписокДокументовПоСтатусам(Элементы.РаскраситьПоСтатусам.Пометка, Истина);
	
	// Кнопки ввода на основании
	ЕстьПравоНаПлатежноеПоручение = ПравоДоступа("Редактирование", Метаданные.Документы.ПлатежноеПоручение);
	ЕстьПравоНаСписание 		  = ПравоДоступа("Редактирование", Метаданные.Документы.СписаниеСРасчетногоСчета);
	ЕстьПравоНаРКО 				  = ПравоДоступа("Редактирование", Метаданные.Документы.РасходныйКассовыйОрдер);
	
	Элементы.ФормаПлатежноеПоручение.Видимость = ЕстьПравоНаПлатежноеПоручение;
	
	Если ЕстьПравоНаРКО Тогда
		Элементы.ФормаПлатежныйДокумент.Видимость = Истина;
	ИначеЕсли ЕстьПравоНаСписание Тогда	
		Элементы.ФормаПлатежныйДокумент.Видимость = Истина;
	Иначе	
		Элементы.ФормаПлатежныйДокумент.Видимость = Ложь;
	КонецЕсли; 

	// +СБ. Широков Николай. 2014-09-04. 
	//СБ_КазначействоКлиент.ЗаявкаНаРасходованиеДСФормаСпискаПриОткрытии(ЭтаФорма);
	ИжТиСи_СВД_Сервер.ОК_ВывестиРеквизиты(ЭтаФорма, "Документ.бит_ЗаявкаНаРасходованиеСредств.ФормаСпискаУправляемая");
	// -СБ. Широков Николай 		
	//ОК Довбешка 11.03.2015
	//ДатаЗамера =  ТекущаяДата();
	//Время = ДатаЗамера - МоментОткрытия;
	//КлючеваяОперация = Справочники.КлючевыеОперации.НайтиПоКоду("000000117");
	//ТекНабор = РегистрыСведений.ОК_ЗамерыВремени_ОткрытияФорм.СоздатьНаборЗаписей();
	//ТекНабор.Отбор.ДатаЗамера.Установить(ДатаЗамера);
	//ТекНабор.Отбор.КлючеваяОперация.Установить(КлючеваяОперация);
	//
	//Запись = ТекНабор.Добавить();
	//Запись.ДатаЗамера = ДатаЗамера;
	//Запись.КлючеваяОперация = КлючеваяОперация;
	//Запись.Информация = "Форма списка";
	//Запись.ВремяВыполнения = Время;
	//Запись.Пользователь = ПараметрыСеанса.ТекущийПользователь;
	//Запись.Компьютер = ИмяКомпьютера();
	//Попытка
	//	ТекНабор.Записать();
	//Исключение
	//КонецПопытки;
	//ОК Довбешка
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеОсновнойОрганизации" Тогда
		бит_РаботаСДиалогамиКлиент.ИзменитьОтборПоОсновнойОрганизации(Список, ,Параметр);		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)

	Если Не Копирование Тогда
		
		Отказ = Истина;
		
		ОписаниеОповещенияОЗавершении = Новый ОписаниеОповещения("СписокПередНачаломДобавленияЗавершение", ЭтотОбъект);
		
		СписокСоздаваемыхДокументов = Новый СписокЗначений;
		СписокСоздаваемыхДокументов.Добавить("Базналичные",НСтр("ru = 'Базналичные'"));
		СписокСоздаваемыхДокументов.Добавить("Наличные",НСтр("ru = 'Наличные'"));
		
		ПоказатьВыборИзМеню(ОписаниеОповещенияОЗавершении, СписокСоздаваемыхДокументов, Элемент);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавленияЗавершение(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныйЭлемент = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ВыбранныйЭлемент.Значение = "Базналичные" Тогда
		СоздатьЗаявкуБезналичные(Неопределено);
	Иначе	
		СоздатьЗаявкуНаличные(Неопределено);
	КонецЕсли; 
	
КонецПроцедуры
	
&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	
	бит_РаботаСДиалогамиСервер.ВосстановитьОтборСписка(Список, Настройки, "Организация");
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ТекущиеДанные.Свойство("ФормаОплаты")  Тогда
		Возврат;
	КонецЕсли; 
	
	Если ТекущиеДанные.ФормаОплаты = ПредопределенноеЗначение("Перечисление.бит_ВидыДенежныхСредств.Безналичные") Тогда
		ТекстСообщения = НСтр("ru = 'Списание с расчетного счета'"); 
	Иначе	
		ТекстСообщения = НСтр("ru = 'Выплата наличных'");
	КонецЕсли; 
	Элементы.ФормаПлатежныйДокумент.Заголовок = ТекстСообщения;
	
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

// Процедура назначается динамически действию кнопки командной панели 
// КоманднаяПанель.РаскраситьПоСтатусам
// (обработчик события "Нажатие" кнопки "РаскраситьПоСтатусам").
//
&НаКлиенте
Процедура Подключаемый_РаскраситьПоСтатусам()
	
	Элементы.РаскраситьПоСтатусам.Пометка = Не Элементы.РаскраситьПоСтатусам.Пометка;
	ОформитьСписокДокументовПоСтатусам(Элементы.РаскраситьПоСтатусам.Пометка);	
		
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗаявкуБезналичные(Команда)
	
	СтруктураОтбора = ОбщегоНазначенияБПВызовСервера.ЗначенияЗаполненияДинамическогоСписка(Список.КомпоновщикНастроек);
	
	Если СтруктураОтбора.Свойство("ДатаОтбора") Тогда
		СтруктураОтбора.Вставить("Дата", СтруктураОтбора.ДатаОтбора);
	КонецЕсли;
	
	СтруктураОтбора.Вставить("ФормаОплаты", ПредопределенноеЗначение("Перечисление.бит_ВидыДенежныхСредств.Безналичные"));
	
	ОткрытьФорму("Документ.бит_ЗаявкаНаРасходованиеСредств.ФормаОбъекта",
		Новый Структура("ЗначенияЗаполнения", СтруктураОтбора), ЭтотОбъект);
		
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗаявкуНаличные(Команда)
	
	СтруктураОтбора = ОбщегоНазначенияБПВызовСервера.ЗначенияЗаполненияДинамическогоСписка(Список.КомпоновщикНастроек);
	
	Если СтруктураОтбора.Свойство("ДатаОтбора") Тогда
		СтруктураОтбора.Вставить("Дата", СтруктураОтбора.ДатаОтбора);
	КонецЕсли;
	
	СтруктураОтбора.Вставить("ФормаОплаты", ПредопределенноеЗначение("Перечисление.бит_ВидыДенежныхСредств.Наличные"));
	
	ОткрытьФорму("Документ.бит_ЗаявкаНаРасходованиеСредств.ФормаОбъекта",
		Новый Структура("ЗначенияЗаполнения", СтруктураОтбора), ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура СоздатьНаОснованииПлатежноеПоручение(Команда)
	
	СоздатьПлатежныйДокумент("Поручение");
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНаОснованииПлатежныйДокумент(Команда)
	
	СоздатьПлатежныйДокумент("Списание");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура обновляет оформление списка документов по статусам
//
// Параметры:
//  ТолькоОчистить - Булево. 
// 
&НаСервере
Процедура ОформитьСписокДокументовПоСтатусам(ПометкаКн, ЭтоОткрытие = Ложь)

	Если ЭтоОткрытие И Не ПометкаКн Тогда
		Возврат;	
	КонецЕсли;
	
	МетаданныеОбъекта = Метаданные.Документы.бит_ЗаявкаНаРасходованиеСредств;	
	
	МасОбъектов = ?(ПометкаКн, бит_РаботаСДиалогамиСервер.ПолучитьМассивОбъектов(МетаданныеОбъекта), Новый Массив);
	бит_РаботаСДиалогамиСервер.ОформитьСписокДокументовПоСтатусам(МасОбъектов, ПометкаКн, УсловноеОформление);
	
	Если Не ЭтоОткрытие Тогда
		// Сохранение значения пометки.
		РегистрыСведений.бит_СохраненныеЗначения.СохранитьЗнч(Пользователи.ТекущийПользователь(),
			МетаданныеОбъекта, "РаскраситьПоСтатусам_Пометка", ПометкаКн);
	КонецЕсли;
															
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПлатежныйДокумент(ВидДокумента)

	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	Реквизиты = Новый Структура("Ссылка, Статус, ВалютаДокумента, ФормаОплаты");
	ЗаполнитьЗначенияСвойств(Реквизиты, ТекущиеДанные);
	
	Для каждого Реквизит Из Реквизиты Цикл
		Если НЕ ЗначениеЗаполнено(Реквизит.Значение) Тогда
			ТекстСообщения = НСтр("ru = 'Команда не может быть выполнена для указанного объекта.'");
			ВызватьИсключение ТекстСообщения; 
		КонецЕсли; 
	КонецЦикла; 
	
	Если ВидДокумента = "Поручение" 
		И Реквизиты.ФормаОплаты = ПредопределенноеЗначение("Перечисление.бит_ВидыДенежныхСредств.Наличные") Тогда
	
		ТекстСообщения = НСтр("ru = 'Ввод ""Платежного поручения"" для оплаты наличными не поддерживается.'"); 
		ПоказатьПредупреждение(, ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	НовыеДокументы = Новый Массив(); 
	СоздатьПлатежныйДокументНаСервере(ВидДокумента, НовыеДокументы, Реквизиты);
	
	Для каждого Элемент Из НовыеДокументы Цикл
		Если ВидДокумента = "Поручение" Тогда
			ИмяФормыДокумента = "Документ.ПлатежноеПоручение.ФормаОбъекта";
		Иначе
			Если Реквизиты.ФормаОплаты = ПредопределенноеЗначение("Перечисление.бит_ВидыДенежныхСредств.Наличные") Тогда
				ИмяФормыДокумента = "Документ.РасходныйКассовыйОрдер.ФормаОбъекта";
			Иначе	
				ИмяФормыДокумента = "Документ.СписаниеСРасчетногоСчета.ФормаОбъекта";
			КонецЕсли; 
		КонецЕсли;
		
		ПараметрыФормы = Новый Структура("Ключ", Элемент); 
		ОткрытьФорму(ИмяФормыДокумента, ПараметрыФормы);
	КонецЦикла; 
	
КонецПроцедуры

&НаСервере
Процедура СоздатьПлатежныйДокументНаСервере(ВидДокумента, НовыеДокументы, Реквизиты)
	
	Модуль 			= Документы.бит_ЗаявкаНаРасходованиеСредств;
	ПараметрыЗаявки = Модуль.НовыеПараметрыЗаявкиДляСозданияПлатежныхДокументов();
	ЗаполнитьЗначенияСвойств(ПараметрыЗаявки, Реквизиты); 
	
	Модуль.СоздатьНаОснованииПлатежныйДокумент(ВидДокумента, НовыеДокументы, ПараметрыЗаявки);
	
КонецПроцедуры

#КонецОбласти

//ОК Довбешка 11.03.2015
МоментОткрытия	= ТекущаяДата();
//ОК Довбешка
