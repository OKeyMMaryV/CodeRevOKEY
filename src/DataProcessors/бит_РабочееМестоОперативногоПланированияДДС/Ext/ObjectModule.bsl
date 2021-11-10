﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс
	
// Функция инициализирует схему компоновки данных и пользовательские настройки.
// 
// Параметры:
// 	пКомпоновщик - КомпоновщикНастроекКомпоновкиДанных - настройки которые будут заполнены из макета СКД.
// 
// Возвращаемое значение:
// 	АдресСхемыКомпоновкиДанных - строка - адрес временного хранилища, где хранится СКД.
// 
Функция ИнициализироватьКомпоновщик(пКомпоновщик) Экспорт
	
	СхемаКомпоновкиДанных = ПолучитьМакет("ПереченьДокументов");
	
	мНастройкиИзмерений = бит_ОбщиеПеременныеСервер.ЗначениеПеременной("бит_НастройкиДополнительныхИзмерений");
	
	бит_МеханизмДопИзмерений.СформироватьЗаголовкиПолейДополнительныхИзмеренийВСКД(СхемаКомпоновкиДанных, 
																				"НаборДанных1", 
																				мНастройкиИзмерений);
	
	АдресСхемыКомпоновкиДанных = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, Новый УникальныйИдентификатор);
	ИсточникНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемыКомпоновкиДанных);
	
	пКомпоновщик.Инициализировать(ИсточникНастроек);
	пКомпоновщик.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);

	Возврат АдресСхемыКомпоновкиДанных;
	
КонецФункции

#КонецОбласти 	

#КонецЕсли
