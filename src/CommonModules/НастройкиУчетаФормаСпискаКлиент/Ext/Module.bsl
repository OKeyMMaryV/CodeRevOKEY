﻿
////////////////////////////////////////////////////////////////////////////////
// Формы списков настроек учета
// Общие клиентские методы для всех форм списков регистров настроек учета.
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Процедура - реализация метода ПередНачаломДобавления динамического списка формы списка регистра сведений
//
// Параметры:
//  Форма       - Управляемая форма (форма списка регистра)
//  Элемент     - ТаблицаФормы - таблица, для которой вызывается метод.
//  Отказ       - Булево - признак отказа от добавления объекта.
//  Копирование - Булево - определяет режим копирования.
//  Родитель    - для регистра сведений всегда Неопределено.
//  Группа      - Булево - признак добавления группы, для регистра сведений всегда Ложь.
Процедура СписокПередНачаломДобавления(Форма, Элемент, Отказ, Копирование, Родитель, Группа) Экспорт
	
	Если Копирование Тогда
		ТекущаяОрганизация = Форма.Элементы.Список.ТекущиеДанные.Организация;
	Иначе
		ЗначенияЗаполнения = ОбщегоНазначенияБПВызовСервера.ЗначенияЗаполненияДинамическогоСписка(Форма.Список.КомпоновщикНастроек);
		ТекущаяОрганизация = ?(ЗначенияЗаполнения.Свойство("Организация"), ЗначенияЗаполнения.Организация, Неопределено);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекущаяОрганизация) 
		И ОбщегоНазначенияБПВызовСервераПовтИсп.ЭтоОбособленноеПодразделение(ТекущаяОрганизация) Тогда
		ПоказатьПредупреждение( , НСтр("ru='Настройки учета обособленного подразделения не редактируются.
		|Необходимо изменять настройки учета головной организации.'"));
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

// Процедура - реализация метода ПередУдалением динамического списка формы списка регистра сведений
//
// Параметры:
//  Форма         - Управляемая форма (форма списка регистра)
//  Элемент       - ТаблицаФормы - таблица, для которой вызывается метод.
//  Отказ         - Булево - признак отказа от удаления объекта.
//  ИмяОповещения - Строка - имя оповещения, которое требуется послать открытым формам.
Процедура СписокПередУдалением(Форма, Элемент, Отказ, ИмяОповещения = Неопределено) Экспорт
	
	ТекущиеДанные = Форма.Элементы.Список.ТекущиеДанные;
	Если ЗначениеЗаполнено(ТекущиеДанные.Организация) Тогда
		
		Если ОбщегоНазначенияБПВызовСервераПовтИсп.ЭтоОбособленноеПодразделение(ТекущиеДанные.Организация) Тогда
			ПоказатьПредупреждение( , НСтр("ru='Настройки учета обособленного подразделения не редактируются.
				|Необходимо изменять настройки учета головной организации.'"));
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
		Если ИмяОповещения <> Неопределено Тогда
			Форма.ПараметрыОповещения = Новый Структура("Организация, Период", ТекущиеДанные.Организация, ТекущиеДанные.Период);
		КонецЕсли;
		
	КонецЕсли;

	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "АдресХранилищаПереключениеОтложенногоПроведения") Тогда
		// Форма связана с настройками, влияющими на режим отложенного проведения.
		// Запомним состояние "до изменения".
		Форма.АдресХранилищаПереключениеОтложенногоПроведения = 
			НастройкиУчетаВызовСервера.ПодготовитьДанныеДляПереключенияОтложенногоПроведения(Форма.УникальныйИдентификатор, ТекущиеДанные.Организация);
	КонецЕсли;
	
КонецПроцедуры

// Процедура - реализация метода ПослеУдаления динамического списка формы списка регистра сведений
//
// Параметры:
//  Форма          - Управляемая форма (форма списка регистра)
//  ИмяОповещения - Строка - имя оповещения, которое требуется послать открытым формам.
Процедура СписокПослеУдаления(Форма, ИмяОповещения = Неопределено) Экспорт
	
	Если ИмяОповещения <> Неопределено Тогда
		Если ТипЗнч(Форма.ПараметрыОповещения) = Тип("Структура") Тогда
			Оповестить(ИмяОповещения, Форма.ПараметрыОповещения);
			Форма.ПараметрыОповещения = "";
		КонецЕсли;
	КонецЕсли;

	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "АдресХранилищаПереключениеОтложенногоПроведения") Тогда
		РезультатЗаданияПереключенияОтложенногоПроведения = НастройкиУчетаВызовСервера.ПроверитьОтложенноеПроведениеПослеИзмененияНастроек(
			Форма.УникальныйИдентификатор,
			Форма.АдресХранилищаПереключениеОтложенногоПроведения);
	КонецЕсли;
	
	ОбновитьИнтерфейс();

	Если РезультатЗаданияПереключенияОтложенногоПроведения <> Неопределено Тогда
		ПроведениеКлиент.ОжидатьПереключенияОтложенногоПроведения(РезультатЗаданияПереключенияОтложенногоПроведения);
	КонецЕсли;
	
КонецПроцедуры

// Процедура - реализация метода ОбработкаОповещения формы списка регистра сведений
//
// Параметры:
//  Форма      - Управляемая форма (форма списка регистра)
//  ИмяСобытия - Строка - имя события.
//  Параметр   - Произвольный - параметр сообщения.
//  Источник   - источник события.
Процедура ОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник) Экспорт
	
	Если ИмяСобытия = "ИзменениеОсновнойОрганизации" И НЕ ЗначениеЗаполнено(Форма.ОтборОрганизация) Тогда
		ОбщегоНазначенияБПКлиент.ИзменитьОтборПоОсновнойОрганизации(Форма.Список, , Параметр);
	КонецЕсли;
	
	Если ИмяСобытия = "ИзменениеУчетнойПолитики" Тогда
		Форма.Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
