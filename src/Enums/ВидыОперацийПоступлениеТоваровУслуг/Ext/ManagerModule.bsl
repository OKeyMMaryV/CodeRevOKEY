﻿
Функция ПолучитьДоступныеЗначения(Отбор, СтрокаПоиска)
	
	Исключения = Новый Массив;
	Если НЕ ПолучитьФункциональнуюОпцию("ВедетсяПроизводственнаяДеятельность") Тогда
		Исключения.Добавить(Перечисления.ВидыОперацийПоступлениеТоваровУслуг.ВПереработку);
	КонецЕсли;
	Если НЕ ПолучитьФункциональнуюОпцию("ВедетсяУчетОсновныхСредств") Тогда
		Исключения.Добавить(Перечисления.ВидыОперацийПоступлениеТоваровУслуг.УслугиЛизинга);
		Исключения.Добавить(Перечисления.ВидыОперацийПоступлениеТоваровУслуг.Оборудование);
		Исключения.Добавить(Перечисления.ВидыОперацийПоступлениеТоваровУслуг.ОбъектыСтроительства);
	КонецЕсли;
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьФакторинг") Тогда
		Исключения.Добавить(Перечисления.ВидыОперацийПоступлениеТоваровУслуг.УслугиФакторинга);
	КонецЕсли;
	
	ДоступныеЗначения = Новый СписокЗначений;
	
	Для каждого ЗначениеПеречисления Из Метаданные.Перечисления.ВидыОперацийПоступлениеТоваровУслуг.ЗначенияПеречисления Цикл
		
		Если ТипЗнч(СтрокаПоиска) = Тип("Строка")
			И НЕ ПустаяСтрока(СтрокаПоиска)
			И СтрНайти(НРег(ЗначениеПеречисления.Синоним), НРег(СтрокаПоиска)) <> 1 Тогда
			Продолжить;
		КонецЕсли;
		Ссылка = Перечисления.ВидыОперацийПоступлениеТоваровУслуг[ЗначениеПеречисления.Имя];
		Если ТипЗнч(Отбор) = Тип("ПеречислениеСсылка.ВидыОперацийПоступлениеТоваровУслуг")
			И Отбор <> Ссылка Тогда
			Продолжить;
		ИначеЕсли ТипЗнч(Отбор) = Тип("ФиксированныйМассив")
			И Отбор.Найти(Ссылка) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Если Исключения.Найти(Ссылка) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		ДоступныеЗначения.Добавить(Ссылка, ЗначениеПеречисления.Синоним);
		
	КонецЦикла;
	
	Возврат ДоступныеЗначения;
	
КонецФункции

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора         = ПолучитьДоступныеЗначения(Параметры.Отбор, Параметры.СтрокаПоиска);
	
КонецПроцедуры
