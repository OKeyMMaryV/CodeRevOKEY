﻿//ОКЕЙ Лобанов В.И.(СофтЛаб) Начало 2019-09-27 (#3393)
Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаОбъекта" И
	 	 ЗначениеЗаполнено(ПараметрыСеанса.бит_БК_ТекущийИнициатор)		 
	Тогда 
	
		//ОКЕЙ Лобанов В.И.(СофтЛаб) Начало 2021-04-20 (#4130)
		Если Параметры.Свойство("ЗначенияЗаполнения") И
			 ТипЗнч(Параметры.ЗначенияЗаполнения) = Тип("Структура") И
			 Параметры.ЗначенияЗаполнения.Свойство("ок_ВидКорректировки") И
			 Не ЗначениеЗаполнено(Параметры.ЗначенияЗаполнения.ок_ВидКорректировки) Тогда
			Возврат;
		КонецЕсли;
		//ОКЕЙ Лобанов В.И.(СофтЛаб) Конец 2021-04-20 (#4130)
				
		мДоступныхЦФО = Новый Массив;
		соотФД_ЦФО = ПолучитьДоступныеИнициаторуЦФОДляКорректировки(,мДоступныхЦФО);
		Если соотФД_ЦФО.Количество() > 0 Тогда 
			ВыбраннаяФорма = "ФормаДокументаПоВидам";
			Параметры.Вставить("соотФД_ЦФО", 	соотФД_ЦФО);
			Параметры.Вставить("мДоступныхЦФО", мДоступныхЦФО);
			СтандартнаяОбработка = Ложь;
		КонецЕсли;                                               
	КонецЕсли;    		 
	
КонецПроцедуры

Функция ПолучитьДоступныеИнициаторуЦФОДляКорректировки(Инициатор = Неопределено, мДоступныхЦФО = Неопределено, мДоступныхИнициаторов = Неопределено) Экспорт
	
	соотРезультат = Новый Соответствие;
	
	Если Инициатор = Неопределено Тогда 
		Инициатор = ПараметрыСеанса.бит_БК_ТекущийИнициатор;
	КонецЕсли;
	
	Если мДоступныхЦФО = Неопределено Тогда 
		мДоступныхЦФО = Новый Массив;
	КонецЕсли;
	
	Если мДоступныхИнициаторов = Неопределено Тогда 
		мДоступныхИнициаторов = Новый Массив;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	СБ_СоответствиеФД_ЦФО.ЦФО КАК ЦФО,
	|	СБ_СоответствиеФД_ЦФО.Инициатор КАК ФункциональныйДиректор,
	|	&Инициатор КАК Инициатор
	|ПОМЕСТИТЬ ВТ_ИсходныеДанные
	|ИЗ
	|	РегистрСведений.СБ_СоответствиеФД_ЦФО КАК СБ_СоответствиеФД_ЦФО
	|ГДЕ
	|	СБ_СоответствиеФД_ЦФО.ОтветственныйЗаКорректировкуБК = &Инициатор
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СБ_СоответствиеФД_ЦФО.ЦФО,
	|	СБ_СоответствиеФД_ЦФО.Инициатор,
	|	ок_ЗаместителиОтветственныхЗаКорректировкуБКСрезПоследних.ОтветственныйЗаКорректировкуБК
	|ИЗ
	|	РегистрСведений.ок_ЗаместителиОтветственныхЗаКорректировкуБК.СрезПоследних(&ТекущаяДата, ) КАК ок_ЗаместителиОтветственныхЗаКорректировкуБКСрезПоследних
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СБ_СоответствиеФД_ЦФО КАК СБ_СоответствиеФД_ЦФО
	|		ПО ок_ЗаместителиОтветственныхЗаКорректировкуБКСрезПоследних.ОтветственныйЗаКорректировкуБК = СБ_СоответствиеФД_ЦФО.ОтветственныйЗаКорректировкуБК
	|			И (КОНЕЦПЕРИОДА(ок_ЗаместителиОтветственныхЗаКорректировкуБКСрезПоследних.ДатаОкончанияПолномочий, ДЕНЬ) >= &ТекущаяДата
	|				ИЛИ ок_ЗаместителиОтветственныхЗаКорректировкуБКСрезПоследних.ДатаОкончанияПолномочий = ДАТАВРЕМЯ(1, 1, 1))
	|ГДЕ
	|	ок_ЗаместителиОтветственныхЗаКорректировкуБКСрезПоследних.Заместитель = &Инициатор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВТ_ИсходныеДанные.ЦФО КАК ЦФО,
	|	ВТ_ИсходныеДанные.ФункциональныйДиректор КАК ФункциональныйДиректор
	|ИЗ
	|	ВТ_ИсходныеДанные КАК ВТ_ИсходныеДанные
	|ИТОГИ ПО
	|	ФункциональныйДиректор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВТ_ИсходныеДанные.Инициатор КАК Инициатор
	|ИЗ
	|	ВТ_ИсходныеДанные КАК ВТ_ИсходныеДанные";
	
	Запрос.УстановитьПараметр("Инициатор"	,	Инициатор);
	Запрос.УстановитьПараметр("ТекущаяДата"	,	ТекущаяДата());
	РезультатПакет = Запрос.ВыполнитьПакет();
	
	ВыгрузкаДоступныеИнициаторы = РезультатПакет[РезультатПакет.ВГраница()].Выгрузить();
	мДоступныхИнициаторов = ВыгрузкаДоступныеИнициаторы.ВыгрузитьКолонку("Инициатор");
	
	Результат = РезультатПакет[РезультатПакет.ВГраница()-1];
	
	Если Результат.Пустой() Тогда 
		Возврат соотРезультат;
	КонецЕсли;
	
	ВыборкаПоФД = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаПоФД.Следующий() Цикл 
		
		мДоступныхИнициаторов.Добавить(ВыборкаПоФД.ФункциональныйДиректор);
		
		Выборка = ВыборкаПоФД.Выбрать();
		мЦФО = Новый Массив;
		
		Пока Выборка.Следующий() Цикл 
			Если мЦФО.Найти(Выборка.ЦФО) = Неопределено Тогда 
				мЦФО.Добавить(Выборка.ЦФО);
			КонецЕсли;
			
			мДоступныхЦФО.Добавить(Выборка.ЦФО);
		КонецЦикла;
		
		соотРезультат.Вставить(ВыборкаПоФД.ФункциональныйДиректор, мЦФО);
		
	КонецЦикла;
	
	Возврат соотРезультат;
	
КонецФункции

Функция ПроцессСогласованияЗапущен(Ссылка) Экспорт 
	
	Если Ссылка.Проведен Тогда 
		РС_УстановленныеВизы = РегистрыСведений.бит_УстановленныеВизы.СоздатьНаборЗаписей();
		РС_УстановленныеВизы.Отбор.Объект.Установить(Ссылка);
		РС_УстановленныеВизы.Прочитать();
		Возврат РС_УстановленныеВизы.Количество()>0;
		
	Иначе 
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

// Сформировать печатные формы объектов
//
// ВХОДЯЩИЕ:
//   ИменаМакетов    - Строка    - Имена макетов, перечисленные через запятую
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать
//   ПараметрыПечати - Структура - Структура дополнительных параметров печати
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	ИнтеграцияИСПереопределяемый.ЗаполнитьПараметрыОтправки(ПараметрыВывода.ПараметрыОтправки, МассивОбъектов, КоллекцияПечатныхФорм);
	
КонецПроцедуры

Функция ДоступныеДляШаблоновПечатныеФормы() Экспорт
	
	МассивДоступныхПечатныхФорм = Новый Массив;
	
	Возврат МассивДоступныхПечатныхФорм

КонецФункции

#КонецОбласти

#КонецЕсли
//ОКЕЙ Лобанов В.И.(СофтЛаб) Конец 2019-09-27 (#3393)