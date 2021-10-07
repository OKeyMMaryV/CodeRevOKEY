﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
 	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	бит_РаботаСДиалогамиСервер.ФормаВыбораПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтотОбъект);

	// Определение назначения проформы	
	Если Параметры.Свойство("Назначение") Тогда
	
		Назначение = Перечисления.бит_НазначенияПроформ[Параметры.Назначение];
		
	КонецЕсли; 
	
	Если НЕ ЗначениеЗаполнено(Назначение) Тогда
	
		Назначение = Перечисления.бит_НазначенияПроформ.ФормаСбораДанных;
	
	КонецЕсли; 	
	
	Если ЗначениеЗаполнено(Назначение) Тогда
		
		// Установка отбора списка по назначению.		
		ЭлОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Назначение");
		ЭлОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ЭлОтбора.ПравоеЗначение = Назначение;
		ЭлОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		
	Иначе	
		
		// Для каждого конкретного случая нужно вызывать форму выбора программно с установленным параметром назначение.
		ТекстСообщения =  НСтр("ru = 'Данная форма не предназначена для непосредственного использования.'");
		бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения);
		Отказ = Истина;
		
	КонецЕсли; 
	
	// Проверка лицензии.
	бит_ОбщегоНазначения.ПроверитьДоступностьПроформ(Назначение, Отказ);	
	
	// Настройка формы в зависимости от назначения.
	ЭтоФСД = ?(Назначение = Перечисления.бит_НазначенияПроформ.ПроизвольнаяФорма, Ложь, Истина);
	
	Если ЭтоФСД Тогда
		
		Заголовок =  НСтр("ru = 'Формы сбора данных'");
		
	Иначе	
		
		Заголовок =  НСтр("ru = 'Произвольные форма'");
		
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

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