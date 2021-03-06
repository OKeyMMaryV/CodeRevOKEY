//ОКЕЙ Дмитриева В.В. (ПервыйБИТ) Начало 2021-05-20 (#ТП_БП05_ФР12, #ТП_БП05_ФР13)
#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	УстановитьПривилегированныйРежим(Истина);
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ок_ВзаиморасчетыСПодотчетнымиЛицамиОстатки.ДокументРасчетов КАК СписаниеСРасчетногоСчета,
	|	ок_ВзаиморасчетыСПодотчетнымиЛицамиОстатки.СуммаОстаток КАК Сумма,
	|	ок_ВзаиморасчетыСПодотчетнымиЛицамиОстатки.ПодотчетноеЛицо КАК ФизЛицо,
	|	ок_ВзаиморасчетыСПодотчетнымиЛицамиОстатки.Валюта КАК Валюта
	|ИЗ
	|	РегистрНакопления.ок_ВзаиморасчетыСПодотчетнымиЛицами.Остатки(
	|			&ДатаДокумента,
	|			Организация = &Организация
	|				И Валюта = &Валюта
	|				И ПодотчетноеЛицо = &ФизЛицо
	|				И ДокументРасчетов ССЫЛКА Документ.СписаниеСРасчетногоСчета
	|				И НЕ ДокументРасчетов В (&МассивДокументовТЧ)) КАК ок_ВзаиморасчетыСПодотчетнымиЛицамиОстатки
	|ГДЕ
	|	ок_ВзаиморасчетыСПодотчетнымиЛицамиОстатки.СуммаОстаток > 0";
	
	Запрос.УстановитьПараметр("Валюта", Параметры.ВалютаДокумента);
	Запрос.УстановитьПараметр("МассивДокументовТЧ", Параметры.МассивДокументовТЧ);
	Если НачалоДня(Параметры.Дата) = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя()) Тогда
		Запрос.УстановитьПараметр("ДатаДокумента",   Неопределено);
	Иначе	
		Запрос.УстановитьПараметр("ДатаДокумента", Новый Граница(Параметры.Дата, ВидГраницы.Исключая));
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Организация", Параметры.Организация);
	Запрос.УстановитьПараметр("ФизЛицо", Параметры.ФизЛицо);
	
	РезультатЗапроса = Запрос.Выполнить();
	ТаблицаДокументов.Загрузить(РезультатЗапроса.Выгрузить());	
	УстановитьПривилегированныйРежим(Ложь);
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти   

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Перенести(Команда)
	МассивСтрок = Новый Массив;
	Для Каждого Строка Из ТаблицаДокументов Цикл
		Если Строка.Выбран Тогда
			 МассивСтрок.Добавить(Строка);
		 КонецЕсли;
	 КонецЦикла;
	 Если МассивСтрок.Количество() > 0 Тогда
		 ЭтаФорма.Закрыть(МассивСтрок); 
	 Иначе
		 ЭтаФорма.Закрыть(Неопределено);
	 КонецЕсли;
 КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВсе(Команда)
	Для Каждого Строка Из ТаблицаДокументов Цикл 
		Строка.Выбран = Истина;
	КонецЦикла;	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьВыбор(Команда)
	Для Каждого Строка Из ТаблицаДокументов Цикл 
		Строка.Выбран = Ложь;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти  
//ОКЕЙ Дмитриева В.В. (ПервыйБИТ) Конец 2021-05-20 (#ТП_БП05_ФР12, #ТП_БП05_ФР13)