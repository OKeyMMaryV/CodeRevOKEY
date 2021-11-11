﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Список.Параметры.УстановитьЗначениеПараметра("ДатаНачалаДействияПатентнойСистемы",
		УчетУСН.ДатаНачалаДействияПатентнойСистемы());
	
	Список.Параметры.УстановитьЗначениеПараметра("ПредставлениеУСНПатента",            НСтр("ru = 'Упрощенная на основе патента'"));
	Список.Параметры.УстановитьЗначениеПараметра("ПредставлениеПатентнойСистемы",      НСтр("ru = 'Патентная'"));
	Список.Параметры.УстановитьЗначениеПараметра("ПредставлениеЕНВД",                  НСтр("ru = 'ЕНВД'"));
	Список.Параметры.УстановитьЗначениеПараметра("ПредставлениеУСНДоходы",             НСтр("ru = 'Упрощенная (доходы)'"));
	Список.Параметры.УстановитьЗначениеПараметра("ПредставлениеУСНДоходыМинусРасходы", НСтр("ru = 'Упрощенная (доходы минус расходы)'"));
	
	Если Параметры.Отбор.Свойство("Организация") Тогда
		ОтборОрганизация = Параметры.Отбор.Организация;
		ЭлементОтбораОрганизация = ОтборыСписковКлиентСервер.ЭлементОтбораСпискаПоИмени(Список, "Организация");
		Если ЭлементОтбораОрганизация <> Неопределено Тогда
			ЭлементОтбораОрганизация.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		КонецЕсли;
		Элементы.ГруппаОтборОрганизация.Видимость = Истина;
	Иначе
		ОтборОрганизация = ОбщегоНазначенияБПВызовСервера.УстановитьОтборПоОсновнойОрганизации(ЭтаФорма);
		Элементы.ГруппаОтборОрганизация.Видимость = Ложь;
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
	УстановитьУсловноеОформление();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	НастройкиУчетаФормаСпискаКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	
	ОбщегоНазначенияБП.ВосстановитьОтборСписка(Список, Настройки, "Организация");

	ПолеОрганизацияНаименование = Новый ПолеКомпоновкиДанных("Организация.Наименование");
	ПолеОрганизация = Новый ПолеКомпоновкиДанных("Организация");
	
	Для каждого ЭлементНастроек Из Настройки.Элементы Цикл
		
		Если ТипЗнч(ЭлементНастроек) = Тип("ПорядокКомпоновкиДанных") 
		И ЭлементНастроек.ИдентификаторПользовательскойНастройки = Список.КомпоновщикНастроек.Настройки.Порядок.ИдентификаторПользовательскойНастройки Тогда
			
			Для каждого ЭлементПорядка Из ЭлементНастроек.Элементы Цикл
				
				Если ЭлементПорядка.Поле = ПолеОрганизацияНаименование Тогда
					ЭлементПорядка.Поле = ПолеОрганизация;
				КонецЕсли;
				
				Прервать;
				
			КонецЦикла;
			
			Прервать;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Копирование И Элементы.Список.ТекущиеДанные <> Неопределено Тогда
		ТекущаяОрганизация = Элементы.Список.ТекущиеДанные.Организация;
	Иначе
		ЗначенияЗаполнения = ОбщегоНазначенияБПВызовСервера.ЗначенияЗаполненияДинамическогоСписка(Список.КомпоновщикНастроек);
		ТекущаяОрганизация = ?(ЗначенияЗаполнения.Свойство("Организация"), ЗначенияЗаполнения.Организация, Неопределено);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекущаяОрганизация) 
		И ОбщегоНазначенияБПВызовСервераПовтИсп.ЭтоОбособленноеПодразделение(ТекущаяОрганизация) Тогда
		ПоказатьПредупреждение( , НСтр("ru='Система налогообложения обособленного подразделения не редактируется.
		|Необходимо изменять систему налогообложения головной организации.'"));
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередУдалением(Элемент, Отказ)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ЗначениеЗаполнено(ТекущиеДанные.Организация) Тогда
		Если ОбщегоНазначенияБПВызовСервераПовтИсп.ЭтоОбособленноеПодразделение(ТекущиеДанные.Организация) Тогда
			ПоказатьПредупреждение( , НСтр("ru='Система налогообложения обособленного подразделения не редактируется.
				|Необходимо изменять систему налогообложения головной организации.'"));
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
		ПараметрыОповещения = Новый Структура("Организация, Период", ТекущиеДанные.Организация, ТекущиеДанные.Период);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПослеУдаления(Элемент)
	
	НастройкиУчетаФормаСпискаКлиент.СписокПослеУдаления(ЭтотОбъект, "Запись_НастройкиСистемыНалогообложения");
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	
	ИспользоватьДатуИзменения = НастройкиСистемыНалогообложенияФормыВызовСервера.ИспользуетсяДатаИзменения(Форма.ОтборОрганизация);
	Элементы.ДатаИзменения.Видимость = ИспользоватьДатуИзменения;
	Элементы.Период.Видимость = Не ИспользоватьДатуИзменения;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();


	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "Организация");

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"ОтборОрганизация", ВидСравненияКомпоновкиДанных.НеРавно, Справочники.Организации.ПустаяСсылка());

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	

КонецПроцедуры

#КонецОбласти