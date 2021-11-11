﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Список.Параметры.УстановитьЗначениеПараметра("ЕИ251", НСтр("ru = 'л. с'"));
	Список.Параметры.УстановитьЗначениеПараметра("ЕИ999", НСтр("ru = 'Кгс'"));
	Список.Параметры.УстановитьЗначениеПараметра("ЕИ181", НСтр("ru = 'БРТ'"));
	Список.Параметры.УстановитьЗначениеПараметра("ЕИ796", НСтр("ru = 'шт'"));
	
	НастройкиУчетаФормаСписка.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
	Если Параметры.Отбор.Свойство("ОсновноеСредство") И ЗначениеЗаполнено(Параметры.Отбор.ОсновноеСредство) Тогда
		Элементы.ОсновноеСредство.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	НастройкиУчетаФормаСпискаКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)

	Отказ = Истина;

	Если Копирование Тогда
		Возврат;
	КонецЕсли;

	СписокЗначенийВидыЗаписей = Новый СписокЗначений;
	СписокЗначенийВидыЗаписей.Добавить(ПредопределенноеЗначение("Перечисление.ВидЗаписиОРегистрации.Регистрация"), НСтр("ru = 'Регистрация'"));
	СписокЗначенийВидыЗаписей.Добавить(ПредопределенноеЗначение("Перечисление.ВидЗаписиОРегистрации.СнятиеСРегистрационногоУчета"), НСтр("ru = 'Снятие с учета'"));

	ОповещениеОВыбореОперации = Новый ОписаниеОповещения("ВыборИзМенюЗавершение",ЭтотОбъект);

	ПоказатьВыборИзМеню(ОповещениеОВыбореОперации, СписокЗначенийВидыЗаписей);

КонецПроцедуры

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	
	НастройкиУчетаФормаСписка.СписокПередЗагрузкойПользовательскихНастроекНаСервере(ЭтотОбъект, Элемент, Настройки);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПослеУдаления(Элемент)
	Оповестить("ИзмененаИнформацияОС");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьРегистрация(Команда)
	
	ОткрытьФормуРегистрации();
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьСнятиеСРегистрации(Команда)
	
	ОткрытьФормуСнятияСУчета();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыборИзМенюЗавершение(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныйЭлемент <> Неопределено Тогда
		Если ВыбранныйЭлемент.Значение = ПредопределенноеЗначение("Перечисление.ВидЗаписиОРегистрации.Регистрация") Тогда
			ОткрытьФормуРегистрации();			
		ИначеЕсли ВыбранныйЭлемент.Значение = ПредопределенноеЗначение("Перечисление.ВидЗаписиОРегистрации.СнятиеСРегистрационногоУчета") Тогда
			ОткрытьФормуСнятияСУчета();	
		КонецЕсли;	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуРегистрации()
	
	ЗначенияЗаполнения = ОбщегоНазначенияБПВызовСервера.ЗначенияЗаполненияДинамическогоСписка(Список.КомпоновщикНастроек);
	ЗначенияЗаполнения.Вставить("ВидЗаписи", ПредопределенноеЗначение("Перечисление.ВидЗаписиОРегистрации.Регистрация"));	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	ОткрытьФорму("РегистрСведений.РегистрацияТранспортныхСредств.ФормаЗаписи", СтруктураПараметров, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуСнятияСУчета()
	
	ЗначенияЗаполнения = ОбщегоНазначенияБПВызовСервера.ЗначенияЗаполненияДинамическогоСписка(Список.КомпоновщикНастроек);
	ЗначенияЗаполнения.Вставить("ВидЗаписи", ПредопределенноеЗначение("Перечисление.ВидЗаписиОРегистрации.СнятиеСРегистрационногоУчета"));
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	ОткрытьФорму("РегистрСведений.РегистрацияТранспортныхСредств.ФормаЗаписи", СтруктураПараметров, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти