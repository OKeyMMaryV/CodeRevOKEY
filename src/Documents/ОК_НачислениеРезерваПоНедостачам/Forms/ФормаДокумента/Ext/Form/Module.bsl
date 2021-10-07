﻿//+ СБ Прудникова 2011-01-10

&НаСервере
Процедура ОбновитьДаты()
	//ижтиси, шадрин, 19.08.2015(
	ДатаДокумента = ?(ЗначениеЗаполнено(Объект.Дата), Объект.Дата, ТекущаяДата());
	//ижтиси, шадрин, 19.08.2015)
	Объект.ДатаСторно = НачалоМесяца(ДобавитьМесяц(ДатаДокумента,1));
    Объект.Период=рс_ОбщийМодуль.ПолучитьМесяцНачисленияПоДате(ДатаДокумента);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизиты()
	
	//ижтиси, шадрин, 19.08.2015(
	ДатаДокумента = ?(ЗначениеЗаполнено(Объект.Дата), Объект.Дата, ТекущаяДата());
	//ижтиси, шадрин, 19.08.2015)
	Объект.ВидДвиженияМСФО = ПредопределенноеЗначение("Перечисление.БИТ_ВидыДвиженияМСФО.КорректировкаМСФО");		
	Объект.ДатаСторно = КонецМесяца(ДатаДокумента) + 1;
	//Объект.бит_БК_ЦФО = Справочники.Подразделения.НайтиПоКоду("000000004");
	Объект.бит_БК_ЦФОРЦ = Справочники.Подразделения.НайтиПоНаименованию("Логистика административная");
	Объект.бит_БК_ЦФОГМ = Справочники.Подразделения.НайтиПоНаименованию("ГМ Продажи");
	Объект.бит_БК_ЦФОСМ = Справочники.Подразделения.НайтиПоНаименованию("СМ Продажи");

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Стандартные действия при создании на сервере
 	бит_РаботаСДиалогамиСервер.ФормаОбъектаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтаФорма, Объект);
	
	Если Объект.Ссылка.Пустая() Тогда
		ЗаполнитьРеквизиты();
	КонецЕсли;;
	
	Если не РольДоступна("ПолныеПрава") Тогда 
    	Элементы.НастройкиМеханизмаИмпортаДанныхКоманднаяПанель.Доступность	= Ложь;
    	Элементы.НастройкиМеханизмаИмпортаДанных.ТолькоПросмотр	= Истина;
	КонецЕсли;
	
	//ижтиси, шадрин, 19.08.2015(
	ДанныеФайлаСтрк = РеквизитФормыВЗначение("Объект").ДанныеФайла.Получить();
	ДанныеФайлаАдрес = ПоместитьВоВременноеХранилище(ДанныеФайлаСтрк, УникальныйИдентификатор);
	ОбновлениеОтображения_Сервер();
	//ижтиси, шадрин, 19.08.2015)
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ПроверяемыеРеквизиты.Добавить("Организация");
	
КонецПроцедуры

&НаКлиенте
Процедура КоманднаяПанельДанныеЗаполнить(Команда)
	
	ЗагрузитьДанныеИзSQL_Вызов_Функции();
	
КонецПроцедуры

&НаСервере
Процедура КоманднаяПанельДанныеРассчитатьРезерв(Команда)
		
	РассчитатьРезерв_Вызов_Функции();	
	
КонецПроцедуры

&НаКлиенте
Процедура КоманднаяПанель1ЗаполнитьНастройки(Команда)
	
	ЗаполнитьНастройки_Вызов_Функции();
	
КонецПроцедуры

&НаСервере
Функция СоздатьДанныеФайла(ПолноеИмяФайла, ПараметрДвоичныеДанные)	
	
	файл=новый Файл(ПолноеИмяФайла);
	ДанныеФайлаСтрк = Новый Структура("Имя,Расширение,ПолноеИмяФайла,Данные",файл.Имя,файл.Расширение,ПолноеИмяФайла,ПараметрДвоичныеДанные);
	ДанныеФайлаАдрес = ПоместитьВоВременноеХранилище(ДанныеФайлаСтрк, УникальныйИдентификатор);
	ОбновлениеОтображения_Сервер();
	
конецфункции	

&НаКлиенте
Процедура КоманднаяПанельДанныеОткрытьФайл(Команда)
	отказ=ложь;
	//если  не ДанныеФайла.Получить()= неопределено и Вопрос("Заменить файл?",РежимДиалогаВопрос.ДаНет)=КодВозвратаДиалога.Нет тогда   
	//	отказ=Истина;
	//конецесли;
	//
	если не отказ тогда
		Попытка
			ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие); 
			ДиалогОткрытияФайла.МножественныйВыбор = Ложь; 
			ДиалогОткрытияФайла.Фильтр                        = "Лист Excel (*.xls)|*.xls|Лист Excel2007(*.xlsx)|*.xlsx";
			ДиалогОткрытияФайла.Заголовок                        = "Выберите файл Excel";
			ДиалогОткрытияФайла.ПредварительныйПросмотр        = Ложь;
			ДиалогОткрытияФайла.Расширение                    = "xls";
			ДиалогОткрытияФайла.ИндексФильтра                    = 0;
			Если ДиалогОткрытияФайла.Выбрать() Тогда 		
				ПараметрДвоичныеДанные = Новый ДвоичныеДанные(ДиалогОткрытияФайла.ПолноеИмяФайла);
				СоздатьДанныеФайла(ДиалогОткрытияФайла.ПолноеИмяФайла, ПараметрДвоичныеДанные);
				Модифицированность = Истина;
			//	этотобъект.Записать();				
			КонецЕсли;	
		Исключение  		
			сообщить(ОписаниеОшибки());
			Возврат;  		
		КонецПопытки;
	конецесли;
КонецПроцедуры

&НаКлиенте
Процедура КоманднаяПанельДанныеСохранитьФайл(Команда)
	
	Попытка 	
		Если Не ЭтоАдресВременногоХранилища(ДанныеФайлаАдрес) Тогда
			Возврат;
		КонецЕсли;
		ДанныеФайлаСтрк = ПолучитьИзВременногоХранилища(ДанныеФайлаАдрес);
		если не ДанныеФайлаСтрк=неопределено тогда
			ДиалогСохраненияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
			//ДиалогСохраненияФайла.Каталог=ДанныеФайлаСтрк.Каталог;
			ДиалогСохраненияФайла.МножественныйВыбор = Ложь; 
			ДиалогСохраненияФайла.Заголовок                        = "Сохранение";
			ДиалогСохраненияФайла.ПредварительныйПросмотр        = Ложь;
			ДиалогСохраненияФайла.Расширение                    = ДанныеФайлаСтрк.Расширение;
			ДиалогСохраненияФайла.ИндексФильтра                    = 0;
			ДиалогСохраненияФайла.ПолноеИмяФайла=ДанныеФайлаСтрк.ПолноеИмяФайла;
			Если ДиалогСохраненияФайла.Выбрать() Тогда 			
				ДанныеФайлаСтрк.Данные.Записать(ДиалогСохраненияФайла.ПолноеИмяФайла);			
			КонецЕсли;
		конецесли;
	Исключение    		
		сообщить(ОписаниеОшибки());
		Возврат; 		
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Функция ОбновлениеОтображения_Сервер()
	Попытка
		ДанныеФайлаСтрк = ПолучитьИзВременногоХранилища(ДанныеФайлаАдрес);
		ОписаниеФайла = ДанныеФайлаСтрк.Имя;
	исключение	
		ОписаниеФайла=" ________";		
	конецпопытки;	
	
    Элементы.ФайлМеню.Заголовок=ОписаниеФайла;
КонецФункции

&НаКлиенте
Процедура КоманднаяПанельДанныеОчистить(Команда)
	//если не ДанныеФайла.Получить()= неопределено и Вопрос("Удалить файл из документа?",РежимДиалогаВопрос.ДаНет)=КодВозвратаДиалога.Да тогда   				
		ДанныеФайлаАдрес=Неопределено;	
		ОбновлениеОтображения_Сервер();
		//этотобъект.Записать();
    //конецесли;
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	ОбновитьДаты();
КонецПроцедуры

&НаКлиенте
Процедура КоманднаяПанельДанныеОткрытьВExcel(Команда)
	Если Не ЭтоАдресВременногоХранилища(ДанныеФайлаАдрес) Тогда
		Возврат;
	КонецЕсли;
	ДанныеФайлаСтрк = ПолучитьИзВременногоХранилища(ДанныеФайлаАдрес);
	если не ДанныеФайлаСтрк=неопределено тогда   
		Excel=Новый COMОбъект("Excel.Application");		
		имятемп_=КаталогВременныхФайлов()+ДанныеФайлаСтрк.Имя;
		ДанныеФайлаСтрк.Данные.Записать(имятемп_);
		Excel.WorkBooks.Open(имятемп_);	
		Excel.visible=1;
	конецесли;
КонецПроцедуры

&НаСервере
Функция ЗагрузитьДанныеИзSQL_Вызов_Функции()
	_объект=РеквизитФормыВЗначение("Объект");
	_объект.ЗагрузитьДанныеИзSQL();
	ЗначениеВРеквизитФормы(_объект, "Объект");
КонецФункции

&НаСервере
Функция РассчитатьРезерв_Вызов_Функции()
	_объект=РеквизитФормыВЗначение("Объект");
	_объект.РассчитатьРезерв();
	ЗначениеВРеквизитФормы(_объект, "Объект");
КонецФункции

&НаСервере
Функция ЗаполнитьНастройки_Вызов_Функции()
	_объект=РеквизитФормыВЗначение("Объект");
	_объект.ЗаполнитьНастройки();
	ЗначениеВРеквизитФормы(_объект, "Объект");
КонецФункции

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	Если ЭтоАдресВременногоХранилища(ДанныеФайлаАдрес) Тогда
		ДанныеФайлаСтрк = ПолучитьИзВременногоХранилища(ДанныеФайлаАдрес);
	Иначе
		ДанныеФайлаСтрк = Неопределено;
	КонецЕсли;
	
	ТекущийОбъект.ДанныеФайла = Новый ХранилищеЗначения(ДанныеФайлаСтрк,Новый СжатиеДанных(9));
КонецПроцедуры


&НаКлиенте
Процедура ДанныеОбъектПриИзменении(Элемент)
	
	текДанные = Элементы.Данные.ТекущиеДанные;
	ЦелеваяЦФО = ДанныеОбъектПриИзмененииНаСервере(текДанные.Объект);
	текДанные.ЦелеваяЦфО = ЦелеваяЦФО;
	
КонецПроцедуры

// ++ БИТ Amerkulov 06022014 / Изменение функций
&НаСервере
Функция ДанныеОбъектПриИзмененииНаСервере(текДанныеОбъект)
	
	ЦелеваяЦФО = Справочники.Подразделения.ПустаяСсылка();
	Если ЗначениеЗаполнено(текДанныеОбъект) Тогда
		Запрос = Новый Запрос("ВЫБРАТЬ
							  //ижтиси, шадрин, 21.08.2015(
							  //|	бит_БК_ДополнительныеСведенияПоОбъекту.ФорматОбъекта
							  |	бит_БК_ДополнительныеСведенияПоОбъекту.Значение КАК ФорматОбъекта
		                      |ИЗ
							  //|	Справочник.бит_БК_ДополнительныеСведенияПоОбъекту КАК бит_БК_ДополнительныеСведенияПоОбъекту
							  |	РегистрСведений.ДополнительныеСведения КАК бит_БК_ДополнительныеСведенияПоОбъекту
		                      |ГДЕ
		                      |	бит_БК_ДополнительныеСведенияПоОбъекту.Объект = &Объект
							  //|	И бит_БК_ДополнительныеСведенияПоОбъекту.ПометкаУдаления = ЛОЖЬ");
							  |	И бит_БК_ДополнительныеСведенияПоОбъекту.Свойство = &ФорматОбъекта");
							  //ижтиси, шадрин, 21.08.2015)
							  
		Запрос.УстановитьПараметр("Объект", текДанныеОбъект);
		Запрос.УстановитьПараметр("ФорматОбъекта", ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию("Формат объекта"));
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
			
			Если Выборка.ФорматОбъекта  = Перечисления.бит_БК_ФорматОбъекта.ГМ Тогда
				ЦелеваяЦФО = Объект.бит_БК_ЦФОГМ;
			КонецЕсли;
			
			Если Выборка.ФорматОбъекта  = Перечисления.бит_БК_ФорматОбъекта.РЦ Тогда
				ЦелеваяЦФО = Объект.бит_БК_ЦФОРЦ;
			КонецЕсли;
			
			Если Выборка.ФорматОбъекта  = Перечисления.бит_БК_ФорматОбъекта.СМ Тогда
				ЦелеваяЦФО = Объект.бит_БК_ЦФОСМ;
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
	Возврат ЦелеваяЦФО;
	
КонецФункции
// -- БИТ Amerkulov 

