#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ВерсияФорматаВыгрузки(Знач НаДату = Неопределено, ВыбраннаяФорма = Неопределено) Экспорт
	
	Если НаДату = Неопределено Тогда
		НаДату = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Если НаДату > '20080601' Тогда
		Возврат Перечисления.ВерсииФорматовВыгрузки.Версия500;
	ИначеЕсли НаДату > '20050101' Тогда
		Возврат Перечисления.ВерсииФорматовВыгрузки.Версия300;
	КонецЕсли;
	
КонецФункции

Функция ТаблицаФормОтчета() Экспорт
	
	ОписаниеТиповСтрока = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(254));
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("Дата"));
	ОписаниеТиповДата = Новый ОписаниеТипов(МассивТипов, , Новый КвалификаторыДаты(ЧастиДаты.Дата));
	
	ТаблицаФормОтчета = Новый ТаблицаЗначений;
	ТаблицаФормОтчета.Колонки.Добавить("ФормаОтчета",        ОписаниеТиповСтрока);
	ТаблицаФормОтчета.Колонки.Добавить("ОписаниеОтчета",     ОписаниеТиповСтрока, "Утверждена",  20);
	ТаблицаФормОтчета.Колонки.Добавить("ДатаНачалоДействия", ОписаниеТиповДата,   "Действует с", 5);
	ТаблицаФормОтчета.Колонки.Добавить("ДатаКонецДействия",  ОписаниеТиповДата,   "         по", 5);
	ТаблицаФормОтчета.Колонки.Добавить("РедакцияФормы",      ОписаниеТиповСтрока, "Редакция формы", 20);
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2010Кв4";
	НоваяФорма.ОписаниеОтчета     = "Приложение №1 к приказу ФНС России от 15 декабря 2010 г. № ММВ-7-3/730@.";
	НоваяФорма.РедакцияФормы      = "от 15 декабря 2010 г. № ММВ-7-3/730@.";
	НоваяФорма.ДатаНачалоДействия = '2010-12-01';
	НоваяФорма.ДатаКонецДействия  = '2012-06-30';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2012Кв1";
	НоваяФорма.ОписаниеОтчета     = "Приложение №1 к приказу ФНС России от 22 марта 2012 г. № ММВ-7-3/174@.";
	НоваяФорма.РедакцияФормы      = "от 22 марта 2012 г. № ММВ-7-3/174@.";
	НоваяФорма.ДатаНачалоДействия = '2012-07-01';
	НоваяФорма.ДатаКонецДействия  = '2013-11-30';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2015Кв1";
	НоваяФорма.ОписаниеОтчета     = "Приложение №1 к приказу ФНС России от 26 ноября 2014 г. № ММВ-7-3/600@.";
	НоваяФорма.РедакцияФормы      = "от 26 ноября 2014 г. № ММВ-7-3/600@.";
	НоваяФорма.ДатаНачалоДействия = '2014-12-01';
	НоваяФорма.ДатаКонецДействия  = '2016-11-30';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2013Кв4";
	НоваяФорма.ОписаниеОтчета     = "Приложение №1 к приказу ФНС России от 22 марта 2012 г. № ММВ-7-3/174@ (в ред. приказа ФНС России от 14 ноября 2013 г. № ММВ-7-3/501@).";
	НоваяФорма.РедакцияФормы      = "от 14 ноября 2013 г. № ММВ-7-3/501@.";
	НоваяФорма.ДатаНачалоДействия = '2013-12-01';
	НоваяФорма.ДатаКонецДействия  = '2014-12-31';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2016Кв4";
	НоваяФорма.ОписаниеОтчета     = "Приложение №1 к приказу ФНС России от 19 октября 2016 г. № ММВ-7-3/572@.";
	НоваяФорма.РедакцияФормы      = "от 19 октября 2016 г. № ММВ-7-3/572@.";
	НоваяФорма.ДатаНачалоДействия = '2016-12-01';
	НоваяФорма.ДатаКонецДействия  = '2019-11-30';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2019Кв4";
	//ОКЕЙ Сафронов А.А. (СофтЛаб) Начало 2020-12-28 (#4004)
	//НоваяФорма.ОписаниеОтчета     = "Приложение №1 к приказу ФНС России от 23 сентября 2019 г. № ММВ-7-3/475@.";
	//НоваяФорма.РедакцияФормы      = "от 23 сентября 2019 г. № ММВ-7-3/475@.";
	НоваяФорма.ОписаниеОтчета     = "Приложение № 1 к приказу ФНС России от 23.09.2019 № ММВ-7-3/475@.";
	НоваяФорма.РедакцияФормы      = "от 23.09.2019 № ММВ-7-3/475@.";
	//ОКЕЙ Сафронов А.А. (СофтЛаб) Конец 2020-12-28 (#4004)	
	НоваяФорма.ДатаНачалоДействия = '2019-12-01';
	//ОКЕЙ Сафронов А.А. (СофтЛаб) Начало 2020-12-28 (#4004)
	//НоваяФорма.ДатаКонецДействия  = РегламентированнаяОтчетностьКлиентСервер.ПустоеЗначениеТипа(Тип("Дата"));
	НоваяФорма.ДатаКонецДействия  = '2020-12-31';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2020Кв4";
	НоваяФорма.ОписаниеОтчета
	= "Приложение № 1 к приказу ФНС России от 23.09.2019 № ММВ-7-3/475@ (в ред. приказа ФНС России от 11.09.2020 № ЕД-7-3/655@).";
	НоваяФорма.РедакцияФормы      = "от 11.09.2020 № ЕД-7-3/655@.";
	Если ТекущаяДатаСеанса() >= ДатаПримененияФормыВНовойРедакции() Тогда
		НоваяФорма.ДатаНачалоДействия = '2020-12-01';
	Иначе
		НоваяФорма.ДатаНачалоДействия = '2021-01-01';
	КонецЕсли;
	НоваяФорма.ДатаКонецДействия  = РегламентированнаяОтчетностьКлиентСервер.ПустоеЗначениеТипа(Тип("Дата"));
	//ОКЕЙ Сафронов А.А. (СофтЛаб) Конец 2020-12-28 (#4004)	
	
	Возврат ТаблицаФормОтчета;
	
КонецФункции

Функция ДанныеРеглОтчета(ЭкземплярРеглОтчета) Экспорт
	
	ТаблицаДанныхРеглОтчета = ИнтерфейсыВзаимодействияБРО.НовыйТаблицаДанныхРеглОтчета();
	
	//ОКЕЙ Сафронов А.А. (СофтЛаб) Начало 2020-12-28 (#4004)
	//Если ЭкземплярРеглОтчета.ВыбраннаяФорма = "ФормаОтчета2019Кв4" Тогда
	Если ЭкземплярРеглОтчета.ВыбраннаяФорма = "ФормаОтчета2020Кв4"
		ИЛИ ЭкземплярРеглОтчета.ВыбраннаяФорма = "ФормаОтчета2019Кв4" Тогда
	//ОКЕЙ Сафронов А.А. (СофтЛаб) Конец 2020-12-28 (#4004)	
		
		ДанныеРеглОтчета = ЭкземплярРеглОтчета.ДанныеОтчета.Получить();
		Если ТипЗнч(ДанныеРеглОтчета) <> Тип("Структура") Тогда
			Возврат ТаблицаДанныхРеглОтчета;
		КонецЕсли;
		
		Если ДанныеРеглОтчета.Свойство("ОкружениеСохранения") Тогда // отчет сохранен в 2.0
			
		Иначе
			
			Если ДанныеРеглОтчета.ДанныеМногоуровневыхРазделов.Свойство("Раздел1_1") Тогда
				
				НалогКУплате = ДанныеРеглОтчета.ДанныеМногоуровневыхРазделов["Раздел1_1"];
				
				Период = ЭкземплярРеглОтчета.ДатаОкончания;
				
				Аванс = (КонецМесяца(Период) <> КонецГода(Период)); // все платежи, кроме годового - авансы
				
				МестаУплаты = НалогКУплате.Строки[0].ДанныеМногострочныхЧастей["П00011М1"];
				
				Для Каждого МестоУплаты Из МестаУплаты.Строки Цикл
					
					// Федеральный.
					Сумма = ТаблицаДанныхРеглОтчета.Добавить();
					Сумма.Период = Период;
					Сумма.ОКАТО  = МестоУплаты.Данные["П00011М101003"];
					Сумма.КБК    = МестоУплаты.Данные["П00011М103003"];
					Сумма.Сумма  = МестоУплаты.Данные["П00011М104003"];
					Сумма.Аванс  = Аванс;
					
					// Региональный.
					Сумма = ТаблицаДанныхРеглОтчета.Добавить();
					Сумма.Период = Период;
					Сумма.ОКАТО  = МестоУплаты.Данные["П00011М101003"];
					Сумма.КБК    = МестоУплаты.Данные["П00011М106003"];
					Сумма.Сумма  = МестоУплаты.Данные["П00011М107003"];
					Сумма.Аванс  = Аванс;
					
				КонецЦикла;
				
			КонецЕсли;
			
			Если ДанныеРеглОтчета.ДанныеМногоуровневыхРазделов.Свойство("Раздел1_2") Тогда
				
				АвансовыеПлатежи = ДанныеРеглОтчета.ДанныеМногоуровневыхРазделов["Раздел1_2"];
				
				Период = КонецКвартала(ЭкземплярРеглОтчета.ДатаОкончания);
				
				КодСтрокиОКАТО  = "П00012М101003";
				
				КодСтрокиКБК_ФБ = "П00012М111003";
				КодСтрокиСумма_ФБ = Новый Соответствие;
				КодСтрокиСумма_ФБ.Вставить(1, "П00012М112003");
				КодСтрокиСумма_ФБ.Вставить(2, "П00012М113003");
				КодСтрокиСумма_ФБ.Вставить(3, "П00012М114003");
				Если Месяц(Период) = 9 Тогда
					КодСтрокиСумма_ФБ.Вставить(4, "П00012М112003");
					КодСтрокиСумма_ФБ.Вставить(5, "П00012М113003");
					КодСтрокиСумма_ФБ.Вставить(6, "П00012М114003");
				КонецЕсли;
				
				КодСтрокиКБК_РБ = "П00012М121003";
				КодСтрокиСумма_РБ = Новый Соответствие;
				КодСтрокиСумма_РБ.Вставить(1, "П00012М122003");
				КодСтрокиСумма_РБ.Вставить(2, "П00012М123003");
				КодСтрокиСумма_РБ.Вставить(3, "П00012М124003");
				Если Месяц(Период) = 9 Тогда
					КодСтрокиСумма_РБ.Вставить(4, "П00012М122003");
					КодСтрокиСумма_РБ.Вставить(5, "П00012М123003");
					КодСтрокиСумма_РБ.Вставить(6, "П00012М124003");
				КонецЕсли;
				
				МестаУплаты = АвансовыеПлатежи.Строки[0].ДанныеМногострочныхЧастей["П00012М1"];
				
				Для Каждого МестоУплаты Из МестаУплаты.Строки Цикл
					
					ЗначКвартал = СокрЛП(МестоУплаты.Данные["П00012М100103"]);
					
					// Федеральный.
					Для Каждого Месяц Из КодСтрокиСумма_ФБ Цикл
						
						Если ЗначениеЗаполнено(ЗначКвартал) И НЕ МесяцПринадлежитКварталу(ЗначКвартал, Месяц.Ключ) Тогда
							Продолжить;
						КонецЕсли;
						
						Сумма = ТаблицаДанныхРеглОтчета.Добавить();
						Сумма.Период = КонецМесяца(ДобавитьМесяц(Период, Месяц.Ключ));
						Сумма.ОКАТО  = МестоУплаты.Данные[КодСтрокиОКАТО];
						Сумма.КБК    = МестоУплаты.Данные[КодСтрокиКБК_ФБ];
						Сумма.Сумма  = МестоУплаты.Данные[Месяц.Значение];
						Сумма.Аванс  = Истина;
						
					КонецЦикла;
					
					// Региональный.
					Для Каждого Месяц Из КодСтрокиСумма_РБ Цикл
						
						Если ЗначениеЗаполнено(ЗначКвартал) И НЕ МесяцПринадлежитКварталу(ЗначКвартал, Месяц.Ключ) Тогда
							Продолжить;
						КонецЕсли;
						
						Сумма = ТаблицаДанныхРеглОтчета.Добавить();
						Сумма.Период = КонецМесяца(ДобавитьМесяц(Период, Месяц.Ключ));
						Сумма.ОКАТО  = МестоУплаты.Данные[КодСтрокиОКАТО];
						Сумма.КБК    = МестоУплаты.Данные[КодСтрокиКБК_РБ];
						Сумма.Сумма  = МестоУплаты.Данные[Месяц.Значение];
						Сумма.Аванс  = Истина;
						
					КонецЦикла;
					
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЕсли;
		
	ИначеЕсли ЭкземплярРеглОтчета.ВыбраннаяФорма = "ФормаОтчета2016Кв4"
		ИЛИ ЭкземплярРеглОтчета.ВыбраннаяФорма = "ФормаОтчета2015Кв1"
		ИЛИ ЭкземплярРеглОтчета.ВыбраннаяФорма = "ФормаОтчета2013Кв4"
		ИЛИ ЭкземплярРеглОтчета.ВыбраннаяФорма = "ФормаОтчета2012Кв1" Тогда
		
		ДанныеРеглОтчета = ЭкземплярРеглОтчета.ДанныеОтчета.Получить();
		Если ТипЗнч(ДанныеРеглОтчета) <> Тип("Структура") Тогда
			Возврат ТаблицаДанныхРеглОтчета;
		КонецЕсли;
		
		Если ДанныеРеглОтчета.ДанныеМногостраничныхРазделов.Свойство("Раздел1_1") Тогда
			
			НалогКУплате = ДанныеРеглОтчета.ДанныеМногостраничныхРазделов.Раздел1_1;
			
			Период = ЭкземплярРеглОтчета.ДатаОкончания;
			
			Аванс = (КонецМесяца(Период) <> КонецГода(Период)); // все платежи, кроме годового - авансы
			
			КодСтрокиОКАТО    = "П000110001003";
			КодСтрокиКБК_ФБ   = "П000110003003";
			КодСтрокиСумма_ФБ = "П000110004003";
			КодСтрокиКБК_РБ   = "П000110006003";
			КодСтрокиСумма_РБ = "П000110007003";
			
			Для Каждого МестоУплаты Из НалогКУплате Цикл
				
				// Федеральный.
				Сумма = ТаблицаДанныхРеглОтчета.Добавить();
				Сумма.Период = Период;
				Сумма.ОКАТО  = МестоУплаты.Данные[КодСтрокиОКАТО];
				Сумма.КБК    = МестоУплаты.Данные[КодСтрокиКБК_ФБ];
				Сумма.Сумма  = МестоУплаты.Данные[КодСтрокиСумма_ФБ];
				Сумма.Аванс  = Аванс;
				
				// Региональный.
				Сумма = ТаблицаДанныхРеглОтчета.Добавить();
				Сумма.Период = Период;
				Сумма.ОКАТО  = МестоУплаты.Данные[КодСтрокиОКАТО];
				Сумма.КБК    = МестоУплаты.Данные[КодСтрокиКБК_РБ];
				Сумма.Сумма  = МестоУплаты.Данные[КодСтрокиСумма_РБ];
				Сумма.Аванс  = Аванс;
				
			КонецЦикла;
			
		КонецЕсли;
		
		Если ДанныеРеглОтчета.ДанныеМногостраничныхРазделов.Свойство("Раздел1_2") Тогда
			
			АвансовыеПлатежи = ДанныеРеглОтчета.ДанныеМногостраничныхРазделов.Раздел1_2;
			
			Период          = КонецКвартала(ЭкземплярРеглОтчета.ДатаОкончания);
			КодСтрокиОКАТО  = "П000120001003";
			КодСтрокиКБК_ФБ = "П000120011003";
			КодСтрокиСумма_ФБ = Новый Соответствие; 
			КодСтрокиСумма_ФБ.Вставить(1, "П000120012003");
			КодСтрокиСумма_ФБ.Вставить(2, "П000120013003");
			КодСтрокиСумма_ФБ.Вставить(3, "П000120014003");
			
			Если Месяц(Период) = 9 Тогда
				КодСтрокиСумма_ФБ.Вставить(4, "П000120012003");
				КодСтрокиСумма_ФБ.Вставить(5, "П000120013003");
				КодСтрокиСумма_ФБ.Вставить(6, "П000120014003");
			КонецЕсли;
			
			КодСтрокиКБК_РБ = "П000120021003";
			КодСтрокиСумма_РБ = Новый Соответствие; 
			КодСтрокиСумма_РБ.Вставить(1, "П000120022003");
			КодСтрокиСумма_РБ.Вставить(2, "П000120023003");
			КодСтрокиСумма_РБ.Вставить(3, "П000120024003");
			
			Если Месяц(Период) = 9 Тогда
				КодСтрокиСумма_РБ.Вставить(4, "П000120022003");
				КодСтрокиСумма_РБ.Вставить(5, "П000120023003");
				КодСтрокиСумма_РБ.Вставить(6, "П000120024003");
			КонецЕсли;
			
			Для Каждого МестоУплаты Из АвансовыеПлатежи Цикл
				
				ЗначКвартал = "";
				Если ЭкземплярРеглОтчета.ВыбраннаяФорма = "ФормаОтчета2016Кв4"
				 ИЛИ ЭкземплярРеглОтчета.ВыбраннаяФорма = "ФормаОтчета2015Кв1" Тогда
					ЗначКвартал = СокрЛП(МестоУплаты.Данные["П000120000103"]);
				КонецЕсли;
				
				// Федеральный.
				Для Каждого Месяц Из КодСтрокиСумма_ФБ Цикл
					
					Если ЗначениеЗаполнено(ЗначКвартал) И НЕ МесяцПринадлежитКварталу(ЗначКвартал, Месяц.Ключ) Тогда
						Продолжить;
					КонецЕсли;
				
					Сумма = ТаблицаДанныхРеглОтчета.Добавить();
					Сумма.Период = КонецМесяца(ДобавитьМесяц(Период, Месяц.Ключ));
					Сумма.ОКАТО  = МестоУплаты.Данные[КодСтрокиОКАТО];
					Сумма.КБК    = МестоУплаты.Данные[КодСтрокиКБК_ФБ];
					Сумма.Сумма  = МестоУплаты.Данные[Месяц.Значение];
					Сумма.Аванс  = Истина;
					
				КонецЦикла;
				
				// Региональный.
				Для Каждого Месяц Из КодСтрокиСумма_РБ Цикл
					
					Если ЗначениеЗаполнено(ЗначКвартал) И НЕ МесяцПринадлежитКварталу(ЗначКвартал, Месяц.Ключ) Тогда
						Продолжить;
					КонецЕсли;
					
					Сумма = ТаблицаДанныхРеглОтчета.Добавить();
					Сумма.Период = КонецМесяца(ДобавитьМесяц(Период, Месяц.Ключ));
					Сумма.ОКАТО  = МестоУплаты.Данные[КодСтрокиОКАТО];
					Сумма.КБК    = МестоУплаты.Данные[КодСтрокиКБК_РБ];
					Сумма.Сумма  = МестоУплаты.Данные[Месяц.Значение];
					Сумма.Аванс  = Истина;
					
				КонецЦикла;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ТаблицаДанныхРеглОтчета;
	
КонецФункции

Функция ДеревоФормИФорматов() Экспорт
	
	ФормыИФорматы = Новый ДеревоЗначений;
	ФормыИФорматы.Колонки.Добавить("Код");
	ФормыИФорматы.Колонки.Добавить("ДатаПриказа");
	ФормыИФорматы.Колонки.Добавить("НомерПриказа");
	ФормыИФорматы.Колонки.Добавить("ДатаНачалаДействия");
	ФормыИФорматы.Колонки.Добавить("ДатаОкончанияДействия");
	ФормыИФорматы.Колонки.Добавить("ИмяОбъекта");
	ФормыИФорматы.Колонки.Добавить("Описание");
	
	Форма20101201 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "1151006", '2010-12-15', "ММВ-7-3/730@", "ФормаОтчета2010Кв4");
	ОпределитьФорматВДеревеФормИФорматов(Форма20101201, "5.03");
	
	Форма20120101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "1151006", '2012-03-22', "ММВ-7-3/174@", "ФормаОтчета2012Кв1");
	ОпределитьФорматВДеревеФормИФорматов(Форма20120101, "5.04");
	
	Форма20131231 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "1151006", '2013-11-14', "ММВ-7-3/501@", "ФормаОтчета2013Кв4");
	ОпределитьФорматВДеревеФормИФорматов(Форма20131231, "5.05");
	
	Форма20141231 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "1151006", '2014-11-26', "ММВ-7-3/600@", "ФормаОтчета2015Кв1");
	ОпределитьФорматВДеревеФормИФорматов(Форма20141231, "5.06");
	
	Форма2016Кв4 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "1151006", '2016-10-19', "ММВ-7-3/572@", "ФормаОтчета2016Кв4");
	ОпределитьФорматВДеревеФормИФорматов(Форма2016Кв4, "5.07");
	
	Форма2019Кв4 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "1151006", '2019-09-23', "ММВ-7-3/475@", "ФормаОтчета2019Кв4");
	ОпределитьФорматВДеревеФормИФорматов(Форма2019Кв4, "5.08");
	
	//ОКЕЙ Сафронов А.А. (СофтЛаб) Начало 2020-12-28 (#4004)
	Форма2020Кв4 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы,
	"1151006", '2020-09-11', "ЕД-7-3/655@", "ФормаОтчета2020Кв4");
	ОпределитьФорматВДеревеФормИФорматов(Форма2020Кв4, "5.09");
	//ОКЕЙ Сафронов А.А. (СофтЛаб) Конец 2020-12-28 (#4004)	
	
	Возврат ФормыИФорматы;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ОпределитьФормуВДеревеФормИФорматов(ДеревоФормИФорматов, Код, ДатаПриказа = '00010101', НомерПриказа = "", ИмяОбъекта = "",
			ДатаНачалаДействия = '00010101', ДатаОкончанияДействия = '00010101', Описание = "")
	
	НовСтр = ДеревоФормИФорматов.Строки.Добавить();
	НовСтр.Код = СокрЛП(Код);
	НовСтр.ДатаПриказа = ДатаПриказа;
	НовСтр.НомерПриказа = СокрЛП(НомерПриказа);
	НовСтр.ДатаНачалаДействия = ДатаНачалаДействия;
	НовСтр.ДатаОкончанияДействия = ДатаОкончанияДействия;
	НовСтр.ИмяОбъекта = СокрЛП(ИмяОбъекта);
	НовСтр.Описание = СокрЛП(Описание);
	Возврат НовСтр;
	
КонецФункции

Функция ОпределитьФорматВДеревеФормИФорматов(Форма, Версия, ДатаПриказа = '00010101', НомерПриказа = "",
			ДатаНачалаДействия = Неопределено, ДатаОкончанияДействия = Неопределено, ИмяОбъекта = "", Описание = "")
	
	НовСтр = Форма.Строки.Добавить();
	НовСтр.Код = СокрЛП(Версия);
	НовСтр.ДатаПриказа = ДатаПриказа;
	НовСтр.НомерПриказа = СокрЛП(НомерПриказа);
	НовСтр.ДатаНачалаДействия = ?(ДатаНачалаДействия = Неопределено, Форма.ДатаНачалаДействия, ДатаНачалаДействия);
	НовСтр.ДатаОкончанияДействия = ?(ДатаОкончанияДействия = Неопределено, Форма.ДатаОкончанияДействия, ДатаОкончанияДействия);
	НовСтр.ИмяОбъекта = СокрЛП(ИмяОбъекта);
	НовСтр.Описание = СокрЛП(Описание);
	Возврат НовСтр;
	
КонецФункции

Функция МесяцПринадлежитКварталу(ЗначКвартал, Месяц)
	
	Возврат (ЗначКвартал = "21" И Месяц > 3) ИЛИ (ЗначКвартал = "24" И Месяц < 4);
	
КонецФункции

#КонецОбласти

#КонецЕсли

//ОКЕЙ Сафронов А.А. (СофтЛаб) Начало 2020-12-28 (#4004)
Функция ДатаПримененияФормыВНовойРедакции()
	
	Возврат '20210101';
	
КонецФункции
//ОКЕЙ Сафронов А.А. (СофтЛаб) Конец 2020-12-28 (#4004)